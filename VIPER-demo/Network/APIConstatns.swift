//
//  API.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 20/12/2024.
//

import Foundation
import Alamofire

struct Constants {
    struct API {
        struct Queries {
            static let TOKEN = "https://api.themoviedb.org/3/authentication/token/new"
            static let GENRES_LIST = "https://api.themoviedb.org/3/genre/movie/list"
            static let NOW_PLAYING_LIST = "https://api.themoviedb.org/3/movie/now_playing"
            static let FAVOURITES_LIST = "https://api.themoviedb.org/3/account/21695372/favorite/movies"
        }
        
        struct Operations {
            static let OPEN_SESSION = "https://api.themoviedb.org/3/authentication/session/new"
            static let SWITCH_FAVOURITE__STATUS = "https://api.themoviedb.org/3/account/21695372/favorite?session_id=SESSION_ID&api_key=API_KEY"
        }
        
        struct FieldsIds {
            static let TOKEN = "request_token"
            static let SESSION_ID = "session_id"
            static let GENRES_LIST = "genres"
            static let RESULTS = "results"
            static let TOTAL_RESULTS = "total_results"
        }
        
        struct ParametersIds {
            static let TOKEN = "request_token"
            static let LANGUAGE = "language"
            static let PAGE = "page"
        }
        
        struct Placeholders {
            static let SESSION_ID = "SESSION_ID"
            static let API_KEY = "API_KEY"
        }
        
        struct Other {
            static let AUTHORIZATION_HEADERS: HTTPHeaders = ["Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhODZjM2Y5ZWJmMzc4ZGIyNDU2MjBkNzg0ZWZjMjQ4NSIsIm5iZiI6MTczNDUzMzg1OC4yNjcsInN1YiI6IjY3NjJlMmUyZTE0ZTNiY2ZhNzRhMmRhYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.I3nS-QCM8m8MEWwIpA4DBqoIgy541qffevD7hFHVlp4", "accept": "application/json"]


            static let API_KEY = "a86c3f9ebf378db245620d784efc2485"
        }
        
        struct HTTPCodes {
            static let OK = 200
            static let Created = 201
        }
    }
}
