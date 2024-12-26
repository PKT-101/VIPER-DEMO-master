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
    func executeLogin()
}

protocol MovieDetailsModuleViewRenderer: ModuleView {}

class MovieDetailsModule: Module {
    
    var id: Int?
    var movie: Movie?
    
    init(id: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }
    
    internal var viewRenderer: MovieDetailsModuleViewRenderer?
    internal var eventsHandler: MovieDetailsModuleEventsHandler?
    
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
        movie = try! Realm().object(ofType: Movie.self, forPrimaryKey: id)
    }
    
    func refreshData() {}
    
    func executeLogin() {
        Flow.shared.executeLogin()
    }
    
    func pop() {
        Flow.shared.pop()
    }
}
