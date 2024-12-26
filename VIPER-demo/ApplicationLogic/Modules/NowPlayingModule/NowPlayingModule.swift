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
    func showMovieDetails(id: Int)
}


protocol NowPlayingModuleEventsHandler: ModuleEventsHandler {
    func executeLogin()
    func switchFavouriteStatus(movie: Movie)
    func showMovieDetails(id: Int)
}

protocol NowPlayingModuleViewRenderer: ModuleView {
    func setLoginButton()
}

class NowPlayingModule: Module {
    internal var viewRenderer: NowPlayingModuleViewRenderer?
    internal var eventsHandler: NowPlayingModuleEventsHandler?

    var movies: Results<Movie>?
    var filteredMovies: Results<Movie>?
    
    override func prepareModule() -> Module {
        eventsHandler = self
        viewRenderer = self
        
        eventsHandler?.prepareData()
        viewRenderer?.renderView()
        return self
    }
    
    override func refreshModule() {
        eventsHandler!.refreshData()
        viewRenderer!.setLoginButton()
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
        self.view.isUserInteractionEnabled = false
        Huston.shared.renderStatusView(message: "Updating favourites list")
        DataManager.shared.switchFavouriteState(id: movie.id_pk, isFavoirte: !movie.isFavourite) { [self] in
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true
                Huston.shared.renderStatusView(message: "Found " + String(self.movies!.count) + " movies")
                self.movies = try! Realm().objects(Movie.self).sorted(byKeyPath: "title" , ascending: true)
            }
        }
    }
    
    func pop() {}
    
    func executeLogin() {
        Flow.shared.executeLogin()
    }
    
    func showMovieDetails(id: Int) {
        Flow.shared.showMovieDetails(id: id)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.count > 0) {
            let lowercaseSearchtext = searchText.lowercased()
            filteredMovies = movies!.where {
                $0.searchable.contains(lowercaseSearchtext)
            }
        } else {
            filteredMovies = movies
        }
        Huston.shared.renderStatusView(message: "Foumd " + String(filteredMovies!.count) + " matches")

        tableView!.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredMovies = movies
        tableView!.reloadData()
    }
}
