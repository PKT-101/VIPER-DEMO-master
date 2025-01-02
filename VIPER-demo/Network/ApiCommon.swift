//
//  ApiCommon.swift
//  VIPER-demo
//
//  Created by Przemyslaw Korona-Trzebski on 01/01/2025.
//  Copyright © 2025 Tootle. All rights reserved.
//

import Foundation
import Alamofire

class ApiCommon {
    
    func getResponse(response: AFDataResponse<Any>, maxHTTPSucessCode: Int = Constants.API.HTTPCodes.OK, processingBlock: ([String: Any]) -> Void, errorHandler: ((Int?) -> Void)? = nil) {
        guard let httpResponse = response.response else {
            if((errorHandler) != nil) {
                errorHandler!(nil)
            }
            return
        }
        
        let statusCode = httpResponse.statusCode
        
        if(statusCode >= Constants.API.HTTPCodes.OK && statusCode <= maxHTTPSucessCode) {
            if let json = response.data {
                processingBlock(try! JSONSerialization.jsonObject(with: json) as! [String: Any])
            }
            if((errorHandler) != nil) {
                errorHandler!(nil)
                return
            }
        } else if((errorHandler) != nil) {
            if((errorHandler) != nil) {
                errorHandler!(statusCode)
                return
            }
        }
        
        // default error handling
    }
}
