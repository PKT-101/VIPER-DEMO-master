//
//  DataManager.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 20/12/2024.
//

import Foundation
import RealmSwift

let LAST_FETCH_DATE_KEY = "last_fetch_date_key"

actor DataManagerActor {
    static let shared = DataManagerActor()
    
    private init() {}
    
    func appendRecords(newRecords: [Object]) {
        let realm = try! Realm()
        realm.beginWrite()
        realm.add(newRecords, update: .modified)
        try! realm.commitWrite()
    }
    
    func updateFavouriteMovies(favouriteMovies: [Movie]) {
        let realm = try! Realm()
        realm.beginWrite()
        realm.objects(Movie.self).setValue(false, forKey: "isFavourite")
        favouriteMovies.forEach { $0.isFavourite = true }
        realm.add(favouriteMovies, update: .modified)
        try! realm.commitWrite()
        
        /*let fav = realm.objects(Movie.self).where { movie in //select all favourite movies
            movie.isFavourite == true
        }*/
    }
}

class DataManager {
    static let shared = DataManager()
    
    private init() {}
    
    func fetchData(onCompletion: @escaping(Bool) -> Void) {
        let lastFetchDate: Date = UserDefaults.standard.value(forKey: LAST_FETCH_DATE_KEY) as? Date ?? Date(timeIntervalSince1970: 0)
        if(lastFetchDate.timeIntervalSince1970 == 0) {

            MoviesListAPI.shared.fetchGenres { genres in
                Task {
                    await DataManagerActor.shared.appendRecords(newRecords: genres!)
                    print("Gneres ready")
                    await Huston.shared.renderStatusView(message: "Downloaded 0.00%")
                    
                    /*var movies = [Movie]()
                    MoviesListAPI.shared.downloadMoviesPage(endpoint: Constants.API.Queries.NOW_PLAYING_LIST, page: 1) { _movies in
                        var i = 1
                        var j = 1
                        repeat {
                            MoviesListAPI.shared.downloadMoviesPage(endpoint: Constants.API.Queries.NOW_PLAYING_LIST, page: i) { __movies in
                                if(j == MoviesListAPI.totalPages) {
                                    Task {
                                        await DataManagerActor.shared.appendRecords(newRecords: MoviesListAPI.movies)
                                        MoviesListAPI.resetMovies()
                                        UserDefaults.standard.setValue(Date(), forKey: LAST_FETCH_DATE_KEY)
                                        onCompletion(true)
                                    }
                                }
                                /*Task {
                                    var perc = min((Double(j) / Double(MoviesListAPI.self.totalPages)) * 100, 100.00)
                                    await Huston.shared.renderStatusView(message: "Downloaded: " + String(format: "%.2f", perc) + "%")
                                }*/
                                j = j + 1
                            }
                            i = i + 1
                        } while(i <= MoviesListAPI.totalPages)
                    }
                    
                    */
                    await DataManagerActor.shared.appendRecords(newRecords: MoviesListAPI.shared.fetchMovies(favourities: false)!)
                    print("Movies ready")
                    UserDefaults.standard.setValue(Date(), forKey: LAST_FETCH_DATE_KEY)
                    onCompletion(true)
                }
            }
        } else {
            onCompletion(true)
        }
    }
    
    func fetchFavourites() {
        if(Huston.shared.userStatus == .loggedIn) {
            Task {
                await DataManagerActor.shared.updateFavouriteMovies(favouriteMovies: MoviesListAPI.shared.fetchMovies(favourities: true)!)
                print("Favs ready")
            }
        }  else if(Huston.shared.userStatus == .guest){
            Task {
                await DataManagerActor.shared.updateFavouriteMovies(favouriteMovies:[])
            }
        }
    }
    
    func switchFavouriteState(id: Int, isFavoirte: Bool, onCompletion: @escaping() -> Void) {
        if(Huston.shared.userStatus == .loggedIn) {
            FavouritesAPI.shared.updateFavouritesList(id: id, isFavourite: isFavoirte) { result in
                let realm = try! Realm()
                realm.beginWrite()
                let movie = try! Realm().object(ofType: Movie.self, forPrimaryKey: id)
                movie!.isFavourite = !movie!.isFavourite
                try! realm.commitWrite()
                Task {
                    await DataManagerActor.shared.updateFavouriteMovies(favouriteMovies: MoviesListAPI.shared.fetchMovies(favourities: true)!)
                    onCompletion()
                }
            }
        }
    }
}
