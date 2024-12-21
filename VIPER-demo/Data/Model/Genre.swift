//
//  Genre.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 19/12/2024.
//

import RealmSwift
import ObjectMapper

private let ID = "id"
private let NAME = "name"

class Genre: Object, Mappable {
    @Persisted var name: String
    @Persisted(primaryKey: true) var id: Int
    
    override init() {
        super.init()
    }
    
    required init?(map: ObjectMapper.Map) {
        super.init()
        mapping(map: map)
    }
    
    func mapping(map: ObjectMapper.Map) {
        id <- map[ID]
        name <- map[NAME]
    }
}
