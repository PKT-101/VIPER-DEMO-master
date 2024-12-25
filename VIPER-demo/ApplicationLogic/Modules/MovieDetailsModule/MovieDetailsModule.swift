//
//  MovieDetailsModule.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 25/12/2024.
//  Copyright © 2024 Tootle. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

protocol MovieDetailsModuleEventsHandler: ModuleEventsHandler {
    
}

protocol MovieDetailsModuleViewRenderer: ModuleView {}

class MovieDetailsModule: Module {
    
    var movie: Movie?
    
    func setMovie(id: Int) {
        movie = try! Realm().object(ofType: Movie.self, forPrimaryKey: id)
    }
    
    internal var viewRenderer: MovieDetailsModuleViewRenderer?
    internal var eventsHandler: MovieDetailsModuleEventsHandler?

    //var movies: Results<Movie>?
    
    override func prepareModule() -> Module {
        eventsHandler = self
        viewRenderer = self
        viewRenderer?.renderView()
        
        //eventsHandler?.prepareData()
        return self
    }
    
}

extension MovieDetailsModule: MovieDetailsModuleEventsHandler {
    
    func prepareData() {
         
    }
    
    func refreshData() {}
    
    func pop() {
        Flow.shared.pop()
    }
}
