//
//  FavouritesAPI.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 20/12/2024.
//

import Foundation
import Alamofire

class FavouritesAPI: ApiCommon {
    
    static let shared = FavouritesAPI()
    
    override private init() {}
    
    func updateFavouritesList(id: Int, isFavourite: Bool, onCompletion: @escaping (Bool) -> Void)  {
        var urlString = Constants.API.Operations.SWITCH_FAVOURITE__STATUS.replacingOccurrences(of: Constants.API.Placeholders.SESSION_ID, with: SessionAPI.session!).replacingOccurrences(of: Constants.API.Placeholders.API_KEY, with: Constants.API.Other.API_KEY)
        
        let url = URL(string: urlString)!
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
    
        let parameters = ["media_type": "movie", "media_id": id, "favorite": isFavourite] as [String : Any]
        
        AF.request(components.url!, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: Constants.API.Other.AUTHORIZATION_HEADERS).responseJSON { response in
            if((response.response!.statusCode >= 200) && (response.response!.statusCode < 300)) {
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
