//
//  SessionAPI.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 20/12/2024.
//

import Foundation
import Alamofire

class SessionAPI {
    
    static var token: String?
    private static var session: String?
    
    private static let API_GET_REQUEST_TOKEN = "https://api.themoviedb.org/3/authentication/token/new"
    private static let API_REQUEST_TOKEN = "request_token"
    
    static func getSessionToken(onCompletion: @escaping (String?) -> Void)  {
        let url = URL(string: API_GET_REQUEST_TOKEN)!
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        AF.request(components.url!, headers: AUTHORIZATION_HEADERS).responseJSON { response in
            if(response.response?.statusCode == 200) {
                if let json = response.data {
                    let jsonAsDict = try! JSONSerialization.jsonObject(with: json) as! [String: Any]
                    token = (jsonAsDict[API_REQUEST_TOKEN] as! String)
                    onCompletion(token!)
                }
            } else {
                onCompletion(nil)
            }
        }
    }
    
    private static let API_OPEN_SESSION = "https://api.themoviedb.org/3/authentication/session/new"
    private static let API_SESSION_ID = "session_id"
    
    static func getSession(onCompletion: @escaping (Bool) -> Void) {
        let parameters = ["request_token": token!] as [String : String]

        let url = URL(string: API_OPEN_SESSION)!
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        AF.request(components.url!, method: HTTPMethod.post, parameters: parameters, headers: AUTHORIZATION_HEADERS).responseJSON { response in
            if(response.response?.statusCode == 200) {
                if let json = response.data {
                    let jsonAsDict = try! JSONSerialization.jsonObject(with: json) as! [String: Any]
                    session = (jsonAsDict[API_SESSION_ID] as! String)
                    onCompletion(session != nil)
                }
            } else {
                onCompletion(false)
            }
        }
    }
}
