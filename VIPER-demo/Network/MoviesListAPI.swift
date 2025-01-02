//
//  NetworkOperations.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 19/12/2024.
//

import SwiftUI
import Alamofire
import ObjectMapper

class MoviesListAPI: ApiCommon {

    static let shared = MoviesListAPI()
    
    static var totalPages: Int = 0
 
    //static var moviesDict = [String: Movie]()
    
    override private init() {}

    
    func fetchGenres(onCompletion: @escaping ([Genre]?) -> Void) {
        let url = URL(string: Constants.API.Queries.GENRES_LIST)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: Constants.API.ParametersIds.LANGUAGE, value: "en"), // maybe from locale?
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        AF.request(components.url!, headers: Constants.API.Other.AUTHORIZATION_HEADERS).responseJSON { [self] response in
            getResponse(response: response, processingBlock: {jsonAsDict in
                print("result")
                    let genresArray = jsonAsDict[Constants.API.FieldsIds.GENRES_LIST] as! NSArray
                    let genres = Mapper<Genre>().mapArray(JSONArray: genresArray as! [[String : Any]])
                    onCompletion(genres)
            })
        }
    }
    
    func fetchMovies(favourities: Bool) async -> ([Movie]?) {
        var page = 1
        var movies = [Movie]()
        var fetchCompleted = false
        repeat {
            print("Loop" + String(page))
            let movies_ = await fetchMovies(favourites: favourities, page: page)
            if(movies_ != nil) {
                movies.append(contentsOf: movies_!)
                if(movies_!.count == 0) {
                    fetchCompleted = true
                    return movies
                } else {
                    page += 1
                    await Huston.shared.renderStatusView(message: "Downloaded: " + String(format: "%.2f", min((Double(page) / Double(MoviesListAPI.self.totalPages)) * 100, 100.00)) + "%")
                }
            } else {
                fetchCompleted = true
                MoviesListAPI.totalPages = 0
                return movies
            }
        } while (!fetchCompleted)
    }
       
    func fetchMovies(favourites: Bool, page: Int) async -> [Movie]? {
            await withCheckedContinuation{ continuation in
                downloadMoviesPage(endpoint: favourites ? Constants.API.Queries.FAVOURITES_LIST : Constants.API.Queries.NOW_PLAYING_LIST, page: page){ movies in
                    continuation.resume(returning: movies)
            }
        }
    }

    func downloadMoviesPage(endpoint: String, page: Int, completion: @escaping ([Movie]?) -> Void) {
        let url = URL(string: endpoint)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: Constants.API.ParametersIds.LANGUAGE, value: "en-US"), // maybe from locale?
            URLQueryItem(name: Constants.API.ParametersIds.PAGE, value: String(page)),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        AF.request(components.url!, headers: Constants.API.Other.AUTHORIZATION_HEADERS).responseJSON {[self] response in
            getResponse(response: response, processingBlock: {jsonAsDict in
                if(MoviesListAPI.totalPages == 0) {
                    MoviesListAPI.totalPages = jsonAsDict["total_pages"] as! Int
                }
                let moviesArray = jsonAsDict[Constants.API.FieldsIds.RESULTS] as! NSArray
                let movies = Mapper<Movie>().mapArray(JSONArray: moviesArray as! [[String : Any]])
                
                /*var i = 0  // API returns duplicates???
                movies.forEach({ movie in
                    let m = MoviesListAPI.moviesDict.removeValue(forKey: String(movie.id_pk))
                    if(m != nil) {
                        print("Buba " + String(i) + " " + String(m!.id_pk))
                        i = i + 1
                    }
                    MoviesListAPI.moviesDict.updateValue(movie, forKey: String(movie.id_pk))
                })*/
                
                completion(movies)
            })
        }
    }
}
