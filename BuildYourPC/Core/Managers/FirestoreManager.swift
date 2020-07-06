//
//  FirestoreManager.swift
//  BuildMyPC
//
//  Created by Beke Zoltán on 2020. 01. 16..
//  Copyright © 2020. Zoltán Beke. All rights reserved.
//

import UIKit
import Firebase

enum DatabaseRefType: Int {
    
    case unknown = 0
    case Builds = 1
    case Hardwares = 2
    
}

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
    
    func getDatabaseCollectionReference(byType type: DatabaseRefType) -> CollectionReference?{
        
        switch type {
        case .Builds:
            
            return database.collection(DatabaseReferences.Builds)
        case .Hardwares:
            
            return database.collection(DatabaseReferences.Hardwares)
        default:
            return nil
        }
    }
    
    
    func downloadAllData<T: FIRObjectManagerProtocol>(atCollectionReference collectionRef: CollectionReference?, addListener: Bool?, withObjectMapper mapper: T, completionBlock: @escaping (_ error: Error?) -> Void){
        
        guard let collRef = collectionRef else {
            return
        }
        
        collRef.getDocuments { (snap, error) in
            
            guard let snapshot = snap else{
                return
            }
            
            var objects: Array<FIRObject> = []
            
            for child in snapshot.documents{
                   
                if let object = mapper.objectFrom(snapshot: child){
                    objects.append(object)
                }
            }
            
            mapper.addBunchOfData(objects: objects) {
                
                completionBlock(error)
                
                if let addList = addListener, addList == true{
                    self.addListener(atCollectionReference: collRef, withObjectMapper: mapper)
                }
            }
                        
        }
    }
    
    private func addListener<T: FIRObjectManagerProtocol>(atCollectionReference collRef: CollectionReference!, withObjectMapper mapper: T){
        
        collRef.addSnapshotListener({ (querySnap, error) in
            
            guard let snapshot = querySnap else{
                return
            }
            
            snapshot.documentChanges.forEach { (diff) in
                
                if let object = mapper.objectFrom(snapshot: diff.document){
                    
                    if (diff.type == .added){
                        mapper.add(object: object)
                    }
                    else if (diff.type == .modified){
                        mapper.update(object: object)
                    }
                    else if (diff.type == .removed){
                        mapper.remove(object: object)
                    }
                    
                }
                
            }
            
        })
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    func downloadAllHardwares(completionBlock: @escaping (_ error: Error?) -> Void){
//
//        database.collection(DatabaseReferences.Hardwares).getDocuments { (snap, error) in
//
//            guard let snapshot = snap else{
//                return
//            }
//
//            var hardwares: Array<Hardware> = []
//
//            for child in snapshot.documents{
//
//                if let object = HardwareManager.hardwareFrom(snapshot: child){
//                    hardwares.append(object)
//                }
//            }
//
//            HardwareManager.manager.addBunchOfHardwares(hardwares: hardwares) {
//
//                completionBlock(error)
//
//                self.addListenerForHardwares()
//            }
//
//        }
//    }
//
//    private func addListenerForHardwares(){
//
//        self.hardwaresListener = database.collection(DatabaseReferences.Hardwares).addSnapshotListener({ (querySnap, error) in
//
//            guard let snapshot = querySnap else{
//                return
//            }
//
//            snapshot.documentChanges.forEach { (diff) in
//
//                if let object = HardwareManager.hardwareFrom(snapshot: diff.document){
//
//                    if (diff.type == .added){
//                        HardwareManager.manager.add(hardware: object)
//                    }
//                    else if (diff.type == .modified){
//                        HardwareManager.manager.update(hardware: object)
//                    }
//                    else if (diff.type == .removed){
//                        HardwareManager.manager.remove(hardware: object)
//                    }
//
//                }
//
//            }
//
//        })
//
//    }
    
    
    
}
