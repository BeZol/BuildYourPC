//
//  NavigationBar.swift
//  BuildYourPC
//
//  Created by Beke Zoltán on 2020. 01. 24..
//  Copyright © 2020. Zoltán Beke. All rights reserved.
//

import UIKit

class NavigationBar: UINavigationBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        barTintColor = barTintColor()
        isTranslucent = false
        
        tintColor = titleColor()
        titleTextAttributes = [ NSAttributedString.Key.foregroundColor : titleColor()]
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func barTintColor()->UIColor{
        return UIColor.darkGray
    }
    
    private func titleColor()-> UIColor{
        return UIColor.white
    }
}
