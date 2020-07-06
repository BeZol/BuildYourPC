//
//  BuildManager.swift
//  BuildYourPC
//
//  Created by Beke Zoltán on 2020. 02. 07..
//  Copyright © 2020. Zoltán Beke. All rights reserved.
//

import UIKit
import Firebase

class BuildManager: NSObject,FIRObjectManagerProtocol {

    static let manager  = BuildManager()
     
     private var builds: Array<Build> = []
     
     private override init() {
         super.init()
         
     }
     
     func objectFrom(snapshot snap: QueryDocumentSnapshot?) -> FIRObject? {

         guard let snapshot = snap else {
             return nil
         }

         return Build(withQueryDocumentSnapshot: snapshot)
     }
     
     func addBunchOfData(objects: Array<FIRObject>, completionBlock: @escaping () -> Void) {
         
         Queues.shared.dataHandlerQueue.async(flags: .barrier) {

             for b in objects{
                 
                 if let build = b as? Build{
                     
                     if let bl = self.findBuild(withFirID: build.firID){
                         bl.update(withObject: build)
                     }
                     else{
                         self.builds.append(build)
                     }
                 }
                 
             }
             
             DispatchQueue.main.async {
                 completionBlock()
             }
         }
     }
     
     func add(object obj: FIRObject?) {
         
         guard let exists = obj, let build = exists as? Build  else {
             return
         }
         
         Queues.shared.dataHandlerQueue.async(flags: .barrier) {
             
             if let bl = self.findBuild(withFirID: build.firID){
                 bl.update(withObject: build)
             }
             else{
                 self.builds.append(build)
             }
             
             self.postBuildUpdated(withFirID: build.firID)
         }
     }
     
     func update(object obj: FIRObject?) {
         
         guard let exists = obj, let build = exists as? Build  else {
             return
         }
         
         Queues.shared.dataHandlerQueue.async(flags: .barrier) {
             
             if let bl = self.findBuild(withFirID: build.firID){
                 bl.update(withObject: build)
             }
             else{
                 self.builds.append(build)
             }
             
             self.postBuildUpdated(withFirID: build.firID)
         }
     }
     
     func remove(object obj: FIRObject?) {
         
         guard let exists = obj, let build = exists as? Build  else {
             return
         }
         
         Queues.shared.dataHandlerQueue.async(flags: .barrier) {
             
             if let bl = self.findBuild(withFirID: build.firID), let index = self.builds.firstIndex(of: bl){
                 self.builds.remove(at: index)
                 self.postBuildUpdated(withFirID: build.firID)
             }
             
         }
     }
     
     func getBuilds() -> Array<Build>?{
         
         var bls: Array<Build>? = nil
         Queues.shared.dataHandlerQueue.sync {
             bls = builds
         }
         
         return bls
     }
     
     func getBuild(forFirID fID: String?) -> Build?{
         
         guard let firID = fID else{
             return nil
         }
         
         var build: Build? = nil
         Queues.shared.dataHandlerQueue.sync {
             build = self.findBuild(withFirID: firID)
         }
         
         return build
     }

     private func findBuild(withFirID firID: String) -> Build?{
         
         let filteredArray = self.builds.filter { $0.firID == firID}
         return filteredArray.first
     }
     
     private func postBuildUpdated(withFirID firID: String){
         
         DispatchQueue.main.async {
             
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationID_Build_Updated), object: nil, userInfo: [kNotification_UserInfoKey_Object_Updated_FIRID : firID])
         }
     }
}
