//
//  Helper.swift
//  GhostStory
//
//  Created by Imran Rahman on 5/29/19.
//  Copyright © 2019 InfancyIT. All rights reserved.
//

import UIKit
import SystemConfiguration

final class Helper {
    static var shared = Helper()
    private init() {}
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
}

struct OptionData {
    var name: String?
    var image: UIImage?
}

struct MoreData{
    var name: String?
    var image: UIImage?
}

