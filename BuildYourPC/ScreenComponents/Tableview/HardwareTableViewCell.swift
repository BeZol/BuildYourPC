//
//  HardwareTableViewCell.swift
//  BuildYourPC
//
//  Created by Beke Zoltán on 2020. 02. 07..
//  Copyright © 2020. Zoltán Beke. All rights reserved.
//

import UIKit
import SDWebImage

class HardwareTableViewCell: InfoTableViewCell, UIScrollViewDelegate {

    override class var cellID: String {
        
        get{
            return "kHardwareInfoTableViewCellID"
        }
    }
    
    var pageControl : UIPageControl = {
        let pgcr = UIPageControl()
        pgcr.translatesAutoresizingMaskIntoConstraints = false
        pgcr.backgroundColor = UIColor.clear
        return pgcr
    }()
    
    let scrollView: UIScrollView = {
        let scr = UIScrollView()
        scr.translatesAutoresizingMaskIntoConstraints = false
        return scr
    }()
    
    override func initialize() {
        
        super.initialize()
        
        self.containerView.addSubview(self.scrollView)
        self.containerView.addSubview(self.pageControl)

        scrollView.anchor(top: self.containerView.topAnchor, leading: self.containerView.leadingAnchor, bottom: self.containerView.bottomAnchor, trailing: self.containerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
        pageControl.anchor(top: nil, leading: self.containerView.leadingAnchor, bottom: self.containerView.bottomAnchor, trailing: self.containerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 20))

        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.gray
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
    }
    
    override func willDisplay(object: Any?) {
        super.willDisplay(object: object)
        
        guard let hardware = object as? Hardware else{
            return
        }
        
        self.lblTitle.text = hardware.name
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2

        let locale = Locale.init(identifier: "hu_HU")
        formatter.locale = locale
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        if let formattedPrice = formatter.string(from: hardware.price as NSNumber) {
            self.lblPrice.text = formattedPrice
        }
        else{
            self.lblPrice.text = "Unknown price :("
        }

        self.lblDescription.text = hardware.hardwareDescription
        
        self.avatarImageView.sd_setImage(with: URL(string: hardware.imageURL ?? ""))
        self.avatarImageView.contentMode = .scaleAspectFit
        
        // Find containerView height constrait
        // Set 0 if there isn't any images
        let heightConstraint = (containerView.constraints.filter{$0.firstAttribute == .height}.first)
        if hardware.productImages.count == 0 {
            heightConstraint?.constant = 0
        }
        else{
            heightConstraint?.constant = 200
        }
        
        // Setup scrollView's content size
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(hardware.productImages.count), height: scrollView.frame.size.height)
        
        // Remove all previously added Subviews with tag = 333
        // Tag 333 is just a random number to identify subviews which were added as a UIImageView below
        scrollView.subviews.forEach({
            if $0.tag == 333{
                $0.removeFromSuperview()
            }
        })

        for index in 0..<hardware.productImages.count {

            let subView = UIImageView(frame: CGRect(x: scrollView.frame.size.width * CGFloat(index), y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
            subView.tag = 333
            subView.sd_setImage(with: URL(string: hardware.productImages[index]))
            subView.contentMode = .scaleAspectFit
            scrollView.addSubview(subView)
        }

        self.pageControl.numberOfPages = hardware.productImages.count

    }
    
    // MARK: - Delegates
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}
