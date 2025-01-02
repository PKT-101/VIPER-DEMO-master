//
//  NowPlayingModule.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 21/12/2024.
//

import Foundation
import UIKit
import Realm
import RealmSwift

protocol NowPlayingModuleFlow: LoginFlowProtocol { // exit points from module
    func showMovieDetails()
}


protocol NowPlayingModuleEventsHandler: ModuleEventsHandler {
    func executeLogin()
    func switchFavouritesOnly()
    func switchFavouriteStatus(movie: Movie)
    func showMovieDetails(id: Int)
}

protocol NowPlayingModuleViewRenderer: ModuleView {
    func setLoginButton()
    func setFavoritesOnlyButton()
}

class NowPlayingModule: Module {
    internal weak var viewRenderer: NowPlayingModuleViewRenderer?
    internal weak var eventsHandler: NowPlayingModuleEventsHandler?

    var showFavouritesOnly = false
    var movies: Results<Movie>?
    var filteredMovies: Results<Movie>?
    var searchString = ""
    
    override func prepareModule() -> Module {
        moduleContext = (Flow.shared.dtoDictionary?.removeValue(forKey: DTO.DTO_MODULE_CONTEXT) as? ModuleContext)
        eventsHandler = self
        viewRenderer = self
        
        eventsHandler!.prepareData()
        viewRenderer!.renderView()
        return self
    }
    
    override func refreshModule() {
        eventsHandler!.refreshData()
        
        if(Huston.shared.userStatus == .guest) {
            viewRenderer!.setLoginButton()
        } else {
            viewRenderer!.setFavoritesOnlyButton()
        }
    }
}

extension NowPlayingModule: NowPlayingModuleEventsHandler {
    
    func prepareData() {
        DataManager.shared.fetchFavourites()
        
        movies = try! Realm().objects(Movie.self).sorted(byKeyPath: "title" , ascending: true)
        filteredMovies = movies
        Huston.shared.renderStatusView(message: "Found " + String(movies!.count) + " movies")
    }
    
    func refreshData() {
        DataManager.shared.fetchFavourites()
        Huston.shared.renderStatusView(message: "Found " + String(movies!.count) + " movies")
    }
    
    func switchFavouriteStatus(movie: Movie) {
        Huston.shared.operation(inProgress: true)
        Huston.shared.renderStatusView(message: "Updating favourites list")
        DataManager.shared.switchFavouriteState(id: movie.id_pk, isFavoirte: !movie.isFavourite) { [self] in
            DispatchQueue.main.async {
                Huston.shared.operation(inProgress: false)
                Huston.shared.renderStatusView(message: "Found " + String(self.movies!.count) + " movies")
                self.tableView?.reloadData()
            }
        }
    }
    
    func pop() {}
    
    func executeLogin() {
        Flow.shared.execute {
            Flow.shared.executeLogin()
        }
    }
    
    func switchFavouritesOnly() {
        showFavouritesOnly = !showFavouritesOnly
        
        if(showFavouritesOnly) {
            movies = try! Realm().objects(Movie.self).where{
                $0.isFavourite == true
            }.sorted(byKeyPath: "title" , ascending: true)
        } else {
            movies = try! Realm().objects(Movie.self).sorted(byKeyPath: "title" , ascending: true)
        }
        
        filteredMovies = movies
        filterMovies()
        viewRenderer!.setFavoritesOnlyButton()
        
        Huston.shared.renderStatusView(message: "Foumd " + String(filteredMovies!.count) + " matches")
        tableView!.reloadData()
    }
    
    func showMovieDetails(id: Int) {
        Flow.shared.dtoDictionary!.updateValue(id, forKey: DTO.DTO_MOVIE_ID)
        Flow.shared.execute {
            Flow.shared.showMovieDetails()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchString = searchText.lowercased()
        filterMovies()
        Huston.shared.renderStatusView(message: "Foumd " + String(filteredMovies!.count) + " matches")

        tableView!.reloadData()
    }
    
    func filterMovies() {
        if(searchString.count > 0) {
            filteredMovies = movies!.where {
                $0.searchable.contains(searchString)
            }
        } else {
            filteredMovies = movies
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredMovies = movies
        tableView!.reloadData()
    }
}
