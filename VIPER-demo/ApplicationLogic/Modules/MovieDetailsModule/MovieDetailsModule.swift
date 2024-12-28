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

protocol MovieDetailsModuleEventsHandler: AnyObject, ModuleEventsHandler {
}

protocol MovieDetailsModuleViewRenderer: AnyObject, ModuleView {}

class MovieDetailsModule: Module {
    
    var movie: Movie?
    
    internal weak var viewRenderer: MovieDetailsModuleViewRenderer?
    internal weak var eventsHandler: MovieDetailsModuleEventsHandler?
    
    override func prepareModule() -> Module {
        eventsHandler = self
        viewRenderer = self
        eventsHandler?.prepareData()
        viewRenderer?.renderView()
        return self
    }
}

extension MovieDetailsModule: MovieDetailsModuleEventsHandler {
    
    func prepareData() {
        movie = try! Realm().object(ofType: Movie.self, forPrimaryKey: Flow.shared.dtoDictionary![DTO.DTO_MOVIE_ID])
    }
    
    func refreshData() {}
    
    func pop() {
        Flow.shared.pop()
    }
}
