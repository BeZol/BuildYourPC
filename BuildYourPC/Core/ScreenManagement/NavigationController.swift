//
//  NavigationController.swift
//  BuildYourPC
//
//  Created by Beke Zoltán on 2020. 01. 24..
//  Copyright © 2020. Zoltán Beke. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    lazy var coverView: UIView = {
    
        let view = UIView(frame: .init(x: 0, y: 0, width: self.view.bounds.width, height: 0))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hidesBarsOnSwipe = true
        
        self.view.addSubview(coverView)
        coverView.backgroundColor = .darkGray
        
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let topSafeArea: CGFloat
//        let bottomSafeArea: CGFloat

        if #available(iOS 11.0, *) {
            topSafeArea = view.safeAreaInsets.top
//            bottomSafeArea = view.safeAreaInsets.bottom
        } else {
            topSafeArea = topLayoutGuide.length
//            bottomSafeArea = bottomLayoutGuide.length
        }

        coverView.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, size: CGSize(width: 0, height: topSafeArea))
//        coverView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: topSafeArea)
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return self.topViewController?.preferredStatusBarStyle ?? UIStatusBarStyle.default
    }

    
}
