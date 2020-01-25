//
//  Hardware.swift
//  BuildMyPC
//
//  Created by Beke Zoltán on 2020. 01. 16..
//  Copyright © 2020. Zoltán Beke. All rights reserved.
//

import UIKit
import Firebase

enum HardwareType: Int {
    case unknown = 0
    case motherboard = 1
    case gpu = 2
    
    init(fromRawValue value: Int) {
        
        if let v = HardwareType(rawValue: value){
            self = v
        }
        else{
            self = .unknown
        }
        
    }
}

struct HardwareObject_PropertyNames {
    
    static let name = "name"
    static let description = "description"
    static let price = "price"
    static let productImages = "product_images"
    static let type = "type"
    
}

class Hardware: NSObject {
    
    var firID: String!
    var name: String!
    var hardwareDescription: String?
    var price: Double = 0
    var productImages: Array<String> = []
    var type: HardwareType = .unknown

    
    init(withQueryDocumentSnapshot snapshot: QueryDocumentSnapshot!){
        super.init()
        
        firID = snapshot.documentID
        name = snapshot.get(HardwareObject_PropertyNames.name) as? String
        hardwareDescription = snapshot.get(HardwareObject_PropertyNames.description) as? String
        
        if let pr = snapshot.get(HardwareObject_PropertyNames.price) as? NSNumber{
            price = pr.doubleValue
        }
        
        productImages = snapshot.get(HardwareObject_PropertyNames.productImages) as? Array ?? []

        if let tp = snapshot.get(HardwareObject_PropertyNames.type) as? NSNumber{
            type = HardwareType(fromRawValue: tp.intValue)
        }
        
    }
    
    override convenience init() {
        self.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(withObject obj: Hardware){
        
        self.name = obj.name
        self.hardwareDescription = obj.hardwareDescription
        self.price = obj.price
        self.productImages = obj.productImages
        self.type = obj.type
    }
}
