//
//  GPU.swift
//  BuildMyPC
//
//  Created by Beke Zoltán on 2020. 01. 16..
//  Copyright © 2020. Zoltán Beke. All rights reserved.
//

import UIKit
import Firebase

class GPU: Hardware {

    var length: Double = 0
    
    override init(withQueryDocumentSnapshot snapshot: QueryDocumentSnapshot!) {
        super.init(withQueryDocumentSnapshot: snapshot)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
