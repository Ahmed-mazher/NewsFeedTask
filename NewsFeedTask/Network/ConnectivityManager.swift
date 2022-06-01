//
//  ConnectivityMananger.swift
//  NewsFeedTask
//
//  Created by Rivile on 5/31/22.
//

import Foundation
import Alamofire
import Combine

class ConnectivityMananger: NSObject {

    private override init() {
        super.init()
        setupReachability()
    }
    @Published private (set) var isConnected: Bool = false
    private static let _shared = ConnectivityMananger()

    class func shared() -> ConnectivityMananger {

        return _shared
    }

    private let reachability: NetworkReachabilityManager? = NetworkReachabilityManager()

    var isNetworkAvailable: Bool {
        return reachability?.isReachable ?? false
    }


    private func setupReachability() {
        reachability?.startListening(onQueue: .main, onUpdatePerforming: { [weak self] (status) in
            self?.updateWith(status: status)
        })
    }

    func startListening() {
        reachability?.startListening(onUpdatePerforming: { [weak self] (status) in
            self?.updateWith(status: status)
        })
    }
    func stopListening() {
        reachability?.stopListening()
    }
    
    private func updateWith(status: NetworkReachabilityManager.NetworkReachabilityStatus) {
        switch status {
        case .unknown: fallthrough
        case .notReachable:
            self.isConnected = false
        case .reachable(.ethernetOrWiFi): fallthrough
        case .reachable(.cellular):
            self.isConnected = true
        }
    }
}

