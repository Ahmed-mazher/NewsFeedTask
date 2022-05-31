//
//  ViewController.swift
//  NewsFeedTask
//
//  Created by Rivile on 5/31/22.
//

import UIKit
import Combine


class ViewController: UIViewController {

    var isConnected:Bool = false
    private var connectivitySubscriber:AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConnectivitySubscribers()
    }

    
    func setUpConnectivitySubscribers() {
        
        connectivitySubscriber = ConnectivityMananger.shared().$isConnected.sink(receiveValue: { [weak self](isConnected) in
            //print(isConnected ? "Online" : "Offline")
            self?.isConnected = isConnected
            self?.update()
        })
    }
    

    func update() {
        if isConnected {
            //Fetch from network
            print("network")
        }else{
            //Fetch from local
            print("local")
        }
    }
    
}

