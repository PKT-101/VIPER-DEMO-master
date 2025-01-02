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
    
    internal weak var viewRenderer: MovieDetailsModuleViewRenderer?
    internal weak var eventsHandler: MovieDetailsModuleEventsHandler?
    
    override func prepareModule() -> Module {
        moduleContext = (Flow.shared.dtoDictionary?.removeValue(forKey: DTO.DTO_MODULE_CONTEXT) as? ModuleContext)
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
        Flow.shared.execute {
            Flow.shared.pop()
        }
    }
}
