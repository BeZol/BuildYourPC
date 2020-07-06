//
//  InfoTableViewCell.swift
//  BuildYourPC
//
//  Created by Beke Zoltán on 2020. 01. 31..
//  Copyright © 2020. Zoltán Beke. All rights reserved.
//

import UIKit

class InfoTableViewCell: TableViewCell {

    override class var cellID: String {
        
        get{
            return "kInfoTableViewCellID"
        }
    }
    
    lazy var avatarImageView: UIImageView = {
        
        let view = UIImageView(frame: .zero)
        view.backgroundColor = UIColor.white

        return view
    }()
    
    lazy var lblTitle: UILabel = {
        
        let view = UILabel(frame: .zero)
        view.font = .boldSystemFont(ofSize: 16)
        view.backgroundColor = UIColor.clear
        view.numberOfLines = 1
        return view
    }()

    lazy var lblPrice: UILabel = {
        
        let view = UILabel(frame: .zero)
        view.font = .italicSystemFont(ofSize: 14)
        view.backgroundColor = UIColor.clear
        view.numberOfLines = 1

        return view
    }()
    
    lazy var lblDescription: UILabel = {
        
        let view = UILabel(frame: .zero)
        view.font = .systemFont(ofSize: 12)
        view.backgroundColor = UIColor.clear
        view.numberOfLines = 0
        
        return view
    }()

    lazy var containerView: UIView = {
        
        let view = UIView(frame: .zero)
        return view
    }()


    override func initialize() {
        
        super.initialize()

        self.contentView.addSubview(self.avatarImageView)
        self.contentView.addSubview(self.lblTitle)
        self.contentView.addSubview(self.lblPrice)
        self.contentView.addSubview(self.lblDescription)
        self.contentView.addSubview(self.containerView)

        self.avatarImageView.anchor(top: self.contentView.topAnchor, leading: self.contentView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 12, bottom: 0, right: 0), size: .init(width: 80, height: 80))

        self.lblTitle.anchor(top: self.contentView.topAnchor, leading: self.avatarImageView.trailingAnchor, bottom: nil, trailing: self.contentView.trailingAnchor, padding: UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12), size: CGSize(width: 0, height: 20))
        self.lblPrice.anchor(top: self.lblTitle.bottomAnchor, leading: self.avatarImageView.trailingAnchor, bottom: nil, trailing: self.contentView.trailingAnchor, padding: UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12), size: CGSize(width: 0, height: 20))
//
        self.lblDescription.anchor(top: self.avatarImageView.bottomAnchor, leading: self.contentView.leadingAnchor, bottom: nil, trailing: self.contentView.trailingAnchor, padding: UIEdgeInsets(top: 12, left: 12, bottom: 10, right: 12))
//
        self.containerView.anchor(top: self.lblDescription.bottomAnchor, leading: self.contentView.leadingAnchor, bottom: self.contentView.bottomAnchor, trailing: self.contentView.trailingAnchor, padding: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12), size: CGSize(width: 0, height: 220))
    }
    
    override func willDisplay(object: Any?) {
        super.willDisplay(object: object)
        
        self.lblTitle.text = "Unknown name"
        self.lblPrice.text = "Unknown price :("

        self.lblDescription.text = "Unknown description"
        
    }
        
    override func didEndDisplay(object: Any?) {
        super.didEndDisplay(object: object)
        
        self.avatarImageView.image = nil
        
    }
    
}
