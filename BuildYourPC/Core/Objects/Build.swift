//
//  Build.swift
//  BuildYourPC
//
//  Created by Beke Zoltán on 2020. 02. 07..
//  Copyright © 2020. Zoltán Beke. All rights reserved.
//

import UIKit
import Firebase

struct BuildObject_PropertyNames {
    
    static let name = "name"
    static let description = "description"
    static let price = "price"
    static let productImages = "product_images"
    static let imageURL = "imageURL"
    static let hardwares = "hardwares"

}

class Build: FIRObject {
    
    var name: String!
    var buildDescription: String?
    var price: Double = 0
    var productImages: Array<String> = []
    var imageURL: String?
    var hardwares: [String] = []
    
    required init(withQueryDocumentSnapshot snapshot: QueryDocumentSnapshot!){
        super.init(withQueryDocumentSnapshot: snapshot)
        
        name = snapshot.get(BuildObject_PropertyNames.name) as? String
        buildDescription = snapshot.get(BuildObject_PropertyNames.description) as? String
        
        if let pr = snapshot.get(BuildObject_PropertyNames.price) as? NSNumber{
            price = pr.doubleValue
        }
        
        productImages = snapshot.get(BuildObject_PropertyNames.productImages) as? Array ?? []
        imageURL = snapshot.get(BuildObject_PropertyNames.imageURL) as? String
    
        hardwares = snapshot.get(BuildObject_PropertyNames.hardwares) as? [String] ?? []
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(withObject obj: FIRObject){
        
        guard let build = obj as? Build else {
            return
        }
        
        self.name = build.name
        self.buildDescription = build.buildDescription
        self.price = build.price
        self.productImages = build.productImages
        self.imageURL = build.imageURL
        self.hardwares = build.hardwares
    }
}
