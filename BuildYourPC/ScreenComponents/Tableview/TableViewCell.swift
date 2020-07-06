//
//  TableViewCell.swift
//  BuildYourPC
//
//  Created by Beke Zoltán on 2020. 01. 27..
//  Copyright © 2020. Zoltán Beke. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell,TableViewCellProtocol  {

    class var cellID: String {
        
        get{
            return "kTableViewCellID"
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.white
   
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.initialize()
    }

    func initialize() {

    }
    
    func willDisplay(object: Any?) {
        
        // Must call to refresh autolayout before using frames of views which are rendering by autolayout
        self.layoutIfNeeded()

    }
    
    func didEndDisplay(object: Any?) {
        
    }
    
    
}
