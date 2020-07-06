//
//  Protocols.swift
//  BuildYourPC
//
//  Created by Beke Zoltán on 2020. 01. 31..
//  Copyright © 2020. Zoltán Beke. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol TableViewCellProtocol {
        
    static var cellID: String{get}
    
    func willDisplay(object: Any?)
    func didEndDisplay(object: Any?)
//    static func cellHeight(object: Any?) -> CGFloat
    
}


protocol FIRObjectProtocol {
        
    var firID: String{get}
    
    init(withQueryDocumentSnapshot snapshot: QueryDocumentSnapshot!)
    func update(withObject obj: FIRObject)
}

protocol FIRObjectManagerProtocol {
    
    func objectFrom(snapshot snap: QueryDocumentSnapshot?) -> FIRObject?
    
    func addBunchOfData(objects: Array<FIRObject>, completionBlock: @escaping () -> Void)
    
    func add(object obj: FIRObject?)
    func update(object obj: FIRObject?)
    func remove(object obj: FIRObject?)
    
}
