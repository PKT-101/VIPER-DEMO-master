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
    func switchFavouriteStatus(movie: Movie)
    func showMovieDetails(id: Int)
}

protocol NowPlayingModuleViewRenderer: ModuleView {}

class NowPlayingModule: Module {
    internal var viewRenderer: NowPlayingModuleViewRenderer?
    internal var eventsHandler: NowPlayingModuleEventsHandler?

    var movies: Results<Movie>?
    
    override func prepareModule() -> Module {
        eventsHandler = self
        viewRenderer = self
        viewRenderer?.renderView()
        
        eventsHandler?.prepareData()
        return self
    }
}

extension NowPlayingModule: NowPlayingModuleEventsHandler {
    
    func prepareData() {
        DataManager.shared.fetchFavourites()
        
        movies = try! Realm().objects(Movie.self)
        Huston.shared.renderStatusView(message: "Found " + String(movies!.count) + " movies")
    }
    
    func refreshData() {
        DataManager.shared.fetchFavourites()
    }
    
    func switchFavouriteStatus(movie: Movie) {
        if(Huston.shared.userStatus == .loggedIn) {
            self.view.isUserInteractionEnabled = false
            Huston.shared.renderStatusView(message: "Updating favourites list")
            DataManager.shared.switchFavouriteState(id: movie.id_pk, isFavoirte: !movie.isFavourite) { [self] in
                DispatchQueue.main.async {
                    self.view.isUserInteractionEnabled = true
                    Huston.shared.renderStatusView(message: "Found " + String(self.movies!.count) + " movies")
                    self.movies = try! Realm().objects(Movie.self)
                }
            }
        } else {
            Flow.shared.executeLogin()
        }
    }
    
    func pop() {}
    
    func showMovieDetails(id: Int) {
        Flow.shared.showMovieDetails(id: id)
    }
    
}
