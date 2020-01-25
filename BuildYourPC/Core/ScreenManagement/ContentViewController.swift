//
//  ContentViewController.swift
//  BuildYourPC
//
//  Created by Beke Zoltán on 2020. 01. 24..
//  Copyright © 2020. Zoltán Beke. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
