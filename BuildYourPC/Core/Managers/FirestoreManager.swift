//
//  FirestoreManager.swift
//  BuildMyPC
//
//  Created by Beke Zoltán on 2020. 01. 16..
//  Copyright © 2020. Zoltán Beke. All rights reserved.
//

import UIKit
import Firebase

private struct DatabaseReferences {
    
    static let Builds = "builds"
    static let Hardwares = "hardwares"
    
}

class FirestoreManager: NSObject {

    static let manager  = FirestoreManager()
    
    private var database: Firestore!
    
    private var hardwaresListener: ListenerRegistration?
    
    private override init() {
        super.init()
        
    }
    
    func setup(){
        FirebaseApp.configure()
        database = Firestore.firestore()
    }
    
    func downloadAllHardwares(completionBlock: @escaping (_ error: Error?) -> Void){
        
        database.collection(DatabaseReferences.Hardwares).getDocuments { (snap, error) in
            
            guard let snapshot = snap else{
                return
            }
            
            var hardwares: Array<Hardware> = []
            
            for child in snapshot.documents{
                   
                if let object = HardwareManager.hardwareFrom(snapshot: child){
                    hardwares.append(object)
                }
            }
            
            HardwareManager.manager.addBunchOfHardwares(hardwares: hardwares) {
                
                completionBlock(error)
                
                self.addListenerForHardwares()
            }
                        
        }
    }
    
    private func addListenerForHardwares(){
        
        self.hardwaresListener = database.collection(DatabaseReferences.Hardwares).addSnapshotListener({ (querySnap, error) in
            
            guard let snapshot = querySnap else{
                return
            }
            
            snapshot.documentChanges.forEach { (diff) in
                
                if let object = HardwareManager.hardwareFrom(snapshot: diff.document){
                    
                    if (diff.type == .added){
                        HardwareManager.manager.add(hardware: object)
                    }
                    else if (diff.type == .modified){
                        HardwareManager.manager.update(hardware: object)
                    }
                    else if (diff.type == .removed){
                        HardwareManager.manager.remove(hardware: object)
                    }
                    
                }
                
            }
            
        })
        
    }
    
    
    
}
