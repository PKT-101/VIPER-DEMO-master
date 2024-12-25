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

protocol NowPlayingModuleFlow: LoginProtocol { // exit points from module
    func showMovieDetails(id: Int)
}


protocol NowPlayingModuleEventsHandler: ModuleEventsHandler {}

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
}
