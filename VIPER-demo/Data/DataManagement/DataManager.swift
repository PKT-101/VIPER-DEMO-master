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
        
        let fav = realm.objects(Movie.self).where { a in
            a.isFavourite == true
        }
        print(fav)
    }
}

class DataManager {
    static let actor = DataManagerActor()
    
    static func fetchData(onCompletion: @escaping(Bool) -> Void) {
        let lastFetchDate: Date = UserDefaults.standard.value(forKey: LAST_FETCH_DATE_KEY) as? Date ?? Date(timeIntervalSince1970: 0)
        if(lastFetchDate.timeIntervalSince1970 == 0) {
            MoviesListAPI.fetchGenres { genres in
                Task {
                    await actor.appendRecords(newRecords: genres!)
                    print("Gneres ready")
                    await actor.appendRecords(newRecords: await MoviesListAPI.fetchMovies(favourities: false)!)
                    print("Movies ready")
                    DataManager.fetchFavourites()
                    UserDefaults.standard.setValue(Date(), forKey: LAST_FETCH_DATE_KEY)
                    onCompletion(true)
                }
            }
        } else {
            onCompletion(true)
        }
    }
    
    static func fetchFavourites() {
        if(Huston.shared.userStatus == .loggedIn) {
            Task {
                await actor.updateFavouriteMovies(favouriteMovies: MoviesListAPI.fetchMovies(favourities: true)!)
                print("Favs ready")
            }
        }  else {
            print("Skipping Favs")
        }
    }
    
    static func switchFavouriteState(id: Int) {
        if(Huston.shared.userStatus == .loggedIn) {
            FavouritesAPI.updateFavouritesList(id: id) { result in
                let realm = try! Realm()
                realm.beginWrite()
                let movie = try! Realm().object(ofType: Movie.self, forPrimaryKey: id)
                movie!.isFavourite = !movie!.isFavourite
                try! realm.commitWrite()
                Task {
                    await actor.updateFavouriteMovies(favouriteMovies: MoviesListAPI.fetchMovies(favourities: true)!)
                }
            }
        }
    }
}
