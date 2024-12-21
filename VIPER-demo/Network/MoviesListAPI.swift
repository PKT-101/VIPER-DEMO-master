//
//  NetworkOperations.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 19/12/2024.
//

import SwiftUI
import Alamofire
import ObjectMapper

class MoviesListAPI {
    
    static var downloadStatus: OperationStatus?
    
    private static let API_GENRES_LIST = "https://api.themoviedb.org/3/genre/movie/list"
    private static let API_GENRES_LIST_QUERY_ITEM_LANGUAGE = "language"

    private static let API_GENRES_LIST_KEY = "genres"
    
    static func fetchGenres(onCompletion: @escaping ([Genre]?) -> Void) {
        let url = URL(string: API_GENRES_LIST)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: API_GENRES_LIST_QUERY_ITEM_LANGUAGE, value: "en"), // maybe from locale?
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        AF.request(components.url!, headers: AUTHORIZATION_HEADERS).responseJSON { response in
            if(response.response?.statusCode == 200) {
                if let json = response.data {
                    let jsonAsDict = try! JSONSerialization.jsonObject(with: json) as! [String: Any]
                    let genresArray = jsonAsDict[API_GENRES_LIST_KEY] as! NSArray
                    let genres = Mapper<Genre>().mapArray(JSONArray: genresArray as! [[String : Any]])
                    onCompletion(genres)
                }
            } else {
                onCompletion(nil)
            }
        }
    }
    
    private static let API_MOVIES = "https://api.themoviedb.org/3/movie/now_playing"
    private static let API_FAVOURITE_MOVIES = "https://api.themoviedb.org/3/account/21695372/favorite/movies"
    
    private static let API_MOVIE_LIST_QUERY_ITEM_LANGUAGE = "language"
    private static let API_MOVIE_LIST_QUERY_ITEM_PAGE = "page"
    
    private static let API_MOVIE_LIST_KEY: String = "results"
    private static let API_MOVIE_LIST_RESULTS_COUNT_KEY = "total_results"
    
    static func fetchMovies(favourities: Bool) async -> ([Movie]?) {
        var page = 1
        var movies = [Movie]()
        var fetchCompleted = false
        repeat {
            let movies_ = await fetchMovies(favourites: favourities, page: page)
            if(movies_ != nil) {
                movies.append(contentsOf: movies_!)
                if(movies_!.count == 0) {
                    fetchCompleted = true
                    return movies
                } else {
                    page += 1
                }
            }
        } while (!fetchCompleted)
    }
       
    static func fetchMovies(favourites: Bool, page: Int) async -> [Movie]? {
            await withCheckedContinuation{ continuation in
                downloadJson(endpoint: favourites ? API_FAVOURITE_MOVIES : API_MOVIES, page: page){ movies in
                    continuation.resume(returning: movies)
            }
        }
    }

    private static func downloadJson(endpoint: String, page: Int, completion: @escaping ([Movie]?) -> Void) {
        
        let url = URL(string: endpoint)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: API_MOVIE_LIST_QUERY_ITEM_LANGUAGE, value: "en-US"), // maybe from locale?
            URLQueryItem(name: API_MOVIE_LIST_QUERY_ITEM_PAGE, value: String(page)),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        AF.request(components.url!, headers: AUTHORIZATION_HEADERS).responseJSON { response in
            if(response.response?.statusCode == 200) {
                if let json = response.data {
                    let jsonAsDict = try! JSONSerialization.jsonObject(with: json) as! [String: Any]
                    let moviesArray = jsonAsDict[API_MOVIE_LIST_KEY] as! NSArray
                    let movies = Mapper<Movie>().mapArray(JSONArray: moviesArray as! [[String : Any]])
                    completion(movies)
                } else {
                    completion(nil)
                }
            }
        }
    }
}
