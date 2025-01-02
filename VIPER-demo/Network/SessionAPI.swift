//
//  SessionAPI.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 20/12/2024.
//

import Foundation
import Alamofire

class SessionAPI: ApiCommon {
    
    static var token: String?
    static var session: String?
    
    static let shared = SessionAPI()
    
    override private init() {}
    
    func getSessionToken(onCompletion: @escaping (String?) -> Void)  {
        let url = URL(string: Constants.API.Queries.TOKEN)!
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        AF.request(components.url!, headers: Constants.API.Other.AUTHORIZATION_HEADERS).responseJSON { [self] response in
            getResponse(response: response, processingBlock: {jsonAsDict in
                SessionAPI.token = (jsonAsDict[Constants.API.FieldsIds.TOKEN] as! String)
                onCompletion(SessionAPI.token!)
            })
        }
    }
    
    func getSession(onCompletion: @escaping (Bool) -> Void) {
        let parameters = [Constants.API.ParametersIds.TOKEN: SessionAPI.token!] as [String : String]

        let url = URL(string: Constants.API.Operations.OPEN_SESSION)!
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        AF.request(components.url!, method: HTTPMethod.post, parameters: parameters, headers: Constants.API.Other.AUTHORIZATION_HEADERS).responseJSON { [self] response in
            getResponse(response: response, processingBlock: {jsonAsDict in
                SessionAPI.session = (jsonAsDict[Constants.API.FieldsIds.SESSION_ID] as! String)
                onCompletion(SessionAPI.session != nil)
            })
        }
    }
    
}
