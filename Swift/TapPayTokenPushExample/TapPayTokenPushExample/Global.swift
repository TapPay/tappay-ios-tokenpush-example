//
//  Global.swift
//  TapPayTokenPushExample
//
//  Created by Cherri_TapPay_LukeCho on 2022/8/12.
//

import Foundation

class Global: NSObject {
    
    class func queryParameter(url : URL) -> NSMutableDictionary {
        let queryStrings : NSMutableDictionary = [:]
        for qs in url.query!.components(separatedBy: "&") {
            let key = qs.components(separatedBy: "=").first
            var value = (qs.components(separatedBy: "="))[1]
            value = value.replacingOccurrences(of: "+", with: " ")
            value = value.removingPercentEncoding!
            queryStrings[key ?? ""] = value
        }
        return queryStrings
    }
}
