//
//  FavouritesAPI.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 20/12/2024.
//

import Foundation
import Alamofire

class FavouritesAPI {
    
    private static var session: String?

    private static let API_UPDATE_FAVOURITES_LIST_REQUEST = "https://api.themoviedb.org/3/account/21695372/favorite?session_id=SESSION_ID&api_key=API_KEY"
    private static let SESSION_ID_PLACEHOLDER = "SESSION_ID"
    private static let API_KEY_PLACEHOLDER = "API_KEY"
    private static let API_REQUEST_TOKEN = "request_token"

    static func updateFavouritesList(id: Int, onCompletion: @escaping (Bool) -> Void)  {
        var urlString = API_UPDATE_FAVOURITES_LIST_REQUEST.replacingOccurrences(of: SESSION_ID_PLACEHOLDER, with: SessionAPI.session!).replacingOccurrences(of: API_KEY_PLACEHOLDER, with: API_KEY)
        
        let url = URL(string: urlString)!
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
    
        let parameters = ["media_type": "movie", "media_id": id, "favorite": true] as [String : Any]
        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        AF.request(components.url!, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: AUTHORIZATION_HEADERS).responseJSON { response in
            if(response.response?.statusCode == 201) {
                if let json = response.data {
                    let jsonAsDict = try! JSONSerialization.jsonObject(with: json) as! [String: Any]
                   onCompletion(true)
                }
            } else {
                //onCompletion(nil)
            }
        }
    }
}
