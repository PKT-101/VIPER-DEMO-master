//
//  Movie.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 19/12/2024.
//

import RealmSwift
import ObjectMapper

private let ID = "id"

private let GENRE_IDS = "genre_ids"
private let ADULT = "adult"
private let VIDEO = "video"
private let RELEASE_DATE = "release_date"
private let POPULARITY = "popularity"

private let ORIGINAL_LANGUAGE = "original_language"
private let ORIGINAL_TITLE = "original_title"
private let TITLE = "title"
private let OVERVIEW = "overview"

private let VOTE_AVERAGE = "vote_average"
private let VOTES_COUNT = "votes_count"

private let BACKDROP_PATH = "backdorp_path"
private let POSTER_PATH = "poster_path"

class Movie: Object, Mappable, ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) var id_pk: Int
    
    @Persisted var genreIds: List<Genre>
    @Persisted var adult: Bool
    @Persisted var video: Bool
    @Persisted var releaseDate: Date
    @Persisted var popularity: Double
    
    @Persisted var originalLanguage: String
    @Persisted var originalTitle: String
    @Persisted var title: String
    @Persisted var overview: String
    
    @Persisted var voteAverage: Double
    @Persisted var votesCount: Int
    
    @Persisted var backdropPath: String
    @Persisted var posterPath: String
    
    @Persisted var isFavourite: Bool
    
    override init() {
        super.init()
    }
    
    required init?(map: ObjectMapper.Map) {
        super.init()
        mapping(map: map)
    }
    
    func mapping(map: ObjectMapper.Map) {
        var ma = map.JSON
        id_pk = ma.removeValue(forKey: "id") as! Int
        
        var genres:[Int]?
        genres <- map[GENRE_IDS]
        
        for genreId in genres! {
            let genre = (try! Realm().object(ofType: Genre.self, forPrimaryKey: genreId))
            
            if(genre == nil) {
                // no genre!!! 
            } else {
                self.genreIds.append(Genre(value: genre as Any))
            }
        }
        
        adult <- map[ADULT]
        video <- map[VIDEO]
        releaseDate <- map[RELEASE_DATE]
        popularity <- map[POPULARITY]
        
        originalLanguage <- map[ORIGINAL_LANGUAGE]
        originalTitle <- map[ORIGINAL_TITLE]
        title <- map[TITLE]
        overview <- map[OVERVIEW]
        
        voteAverage <- map[VOTE_AVERAGE]
        votesCount <- map[VOTES_COUNT]
        
        backdropPath <- map[BACKDROP_PATH]
        posterPath <- map[POSTER_PATH]
        
    }
}
