//
//  NavigationController.swift
//  BuildYourPC
//
//  Created by Beke Zoltán on 2020. 01. 24..
//  Copyright © 2020. Zoltán Beke. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return self.topViewController?.preferredStatusBarStyle ?? UIStatusBarStyle.default
    }

}
