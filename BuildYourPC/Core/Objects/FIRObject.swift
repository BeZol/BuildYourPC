//
//  FIRObject.swift
//  BuildYourPC
//
//  Created by Beke Zoltán on 2020. 02. 07..
//  Copyright © 2020. Zoltán Beke. All rights reserved.
//

import UIKit
import Firebase

class FIRObject: NSObject,FIRObjectProtocol {
    
    private var firebaseID: String?
    var firID: String{
        
        get{
            
            guard let firid = firebaseID else {
                return "unknown"
            }
            
            return firid
        }

    }
    
    required init(withQueryDocumentSnapshot snapshot: QueryDocumentSnapshot!) {
        super.init()

        firebaseID = snapshot.documentID

    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(withObject obj: FIRObject) {
        
        
    }
    
}
