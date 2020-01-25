//
//  BuildsViewController.swift
//  BuildYourPC
//
//  Created by Beke Zoltán on 2020. 01. 24..
//  Copyright © 2020. Zoltán Beke. All rights reserved.
//

import UIKit

class BuildsViewController: ContentViewController {

    var btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        self.title = "Builds"
        
        
        btn = UIButton(frame: CGRect(x: (self.screenWidth - 150)/2, y: 10, width: 150, height: 50))
        btn.backgroundColor = UIColor.systemBlue
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle("Hello world", for: .normal)
        btn.addTarget(self, action: #selector(helloWorldPressed), for: .touchUpInside)
        self.view.addSubview(btn)
        
        NotificationCenter.default.addObserver(self, selector: #selector(hardwaresUpdated(notification:)), name: NSNotification.Name(rawValue: kNotificationID_Hardware_Updated), object: nil)

        FirestoreManager.manager.downloadAllHardwares { (error) in
            
            guard let hardwares = HardwareManager.manager.getHardwares() else{
                return
            }
            
            self.btn.setTitle("Got " + String(hardwares.count) + " yoo", for: .normal)
//            self.tableView.reload()
        }
        
    }
    
    @objc func helloWorldPressed(){
        
        let aBuildDetail = BuildDetailsViewController()
        self.navigationController?.pushViewController(aBuildDetail, animated: true)
    }
    
    @objc func hardwaresUpdated(notification: NSNotification){
        
        if let firID = notification.userInfo?[kNotification_UserInfoKey_Hardware_Updated] as? String{
            print("Hardware updated with " + firID)
            
            let updatedHardware = HardwareManager.manager.getHardware(forFirID: firID)
            print(updatedHardware?.name as Any)
            
            self.btn.setTitle(updatedHardware?.name, for: .normal)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
