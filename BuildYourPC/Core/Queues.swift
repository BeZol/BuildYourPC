//
//  Queues.swift
//  BuildMyPC
//
//  Created by Beke Zoltán on 2020. 01. 16..
//  Copyright © 2020. Zoltán Beke. All rights reserved.
//

import UIKit

class Queues: NSObject {

    static let shared  = Queues()
    
    lazy var dataHandlerQueue: dispatch_queue_concurrent_t = {
        return dispatch_queue_concurrent_t(label: "com.ZoltanBeke.BuildMyPC.dataHandlerQueue")
    }()
        
    private override init() {
        super.init()
        
    }
    
}

