//
//  HardwareManager.swift
//  BuildMyPC
//
//  Created by Beke Zoltán on 2020. 01. 16..
//  Copyright © 2020. Zoltán Beke. All rights reserved.
//

import UIKit
import Firebase

class HardwareManager: NSObject,FIRObjectManagerProtocol {
        
    static let manager  = HardwareManager()
    
    private var hardwares: Array<Hardware> = []
    
    private override init() {
        super.init()
        
    }
    
    func objectFrom(snapshot snap: QueryDocumentSnapshot?) -> FIRObject? {

        guard let snapshot = snap else {
            return nil
        }
        
        var object: Hardware? = nil
        if let tp = snapshot.get(HardwareObject_PropertyNames.type) as? NSNumber{
            
            let type = HardwareType(fromRawValue: tp.intValue)
            
            switch type {
            case .gpu:
                object = GPU(withQueryDocumentSnapshot: snapshot)
                break
            case .motherboard:
                object = Motherboard(withQueryDocumentSnapshot: snapshot)
                break
            default: break
                
            }
        }
        
        return object
    }
    
    func addBunchOfData(objects: Array<FIRObject>, completionBlock: @escaping () -> Void) {
        
        Queues.shared.dataHandlerQueue.async(flags: .barrier) {

            for hw in objects{
                
                if let hardware = hw as? Hardware{
                    
                    if let hardW = self.findHardware(withFirID: hardware.firID){
                        hardW.update(withObject: hardware)
                    }
                    else{
                        self.hardwares.append(hardware)
                    }
                }
                
            }
            
            DispatchQueue.main.async {
                completionBlock()
            }
        }
    }
    
    func add(object obj: FIRObject?) {
        
        guard let exists = obj, let hardware = exists as? Hardware  else {
            return
        }
        
        Queues.shared.dataHandlerQueue.async(flags: .barrier) {
            
            if let hardW = self.findHardware(withFirID: hardware.firID){
                hardW.update(withObject: hardware)
            }
            else{
                self.hardwares.append(hardware)
            }
            
            self.postHardwareUpdated(withFirID: hardware.firID)
        }
    }
    
    func update(object obj: FIRObject?) {
        
        guard let exists = obj, let hardware = exists as? Hardware  else {
            return
        }
        
        Queues.shared.dataHandlerQueue.async(flags: .barrier) {
            
            if let hardW = self.findHardware(withFirID: hardware.firID){
                hardW.update(withObject: hardware)
            }
            else{
                self.hardwares.append(hardware)
            }
            
            self.postHardwareUpdated(withFirID: hardware.firID)
        }
    }
    
    func remove(object obj: FIRObject?) {
        
        guard let exists = obj, let hardware = exists as? Hardware  else {
            return
        }
        
        Queues.shared.dataHandlerQueue.async(flags: .barrier) {
            
            if let hardW = self.findHardware(withFirID: hardware.firID), let index = self.hardwares.firstIndex(of: hardW){
                self.hardwares.remove(at: index)
                self.postHardwareUpdated(withFirID: hardware.firID)
            }
            
        }
    }
    
    func getHardwares() -> Array<Hardware>?{
        
        var hards: Array<Hardware>? = nil
        Queues.shared.dataHandlerQueue.sync {
            hards = hardwares
        }
        
        return hards
    }
    
    func getHardware(forFirID fID: String?) -> Hardware?{
        
        guard let firID = fID else{
            return nil
        }
        
        var hardware: Hardware? = nil
        Queues.shared.dataHandlerQueue.sync {
            hardware = self.findHardware(withFirID: firID)
        }
        
        return hardware
    }

    private func findHardware(withFirID firID: String) -> Hardware?{
        
        let filteredArray = self.hardwares.filter { $0.firID == firID}
        return filteredArray.first
    }
    
    private func postHardwareUpdated(withFirID firID: String){
        
        DispatchQueue.main.async {
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationID_Hardware_Updated), object: nil, userInfo: [kNotification_UserInfoKey_Object_Updated_FIRID : firID])
        }
    }
}
