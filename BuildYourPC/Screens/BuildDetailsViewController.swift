//
//  BuildDetailViewController.swift
//  BuildYourPC
//
//  Created by Beke Zoltán on 2020. 01. 24..
//  Copyright © 2020. Zoltán Beke. All rights reserved.
//

import UIKit

class BuildDetailsViewController: ContentViewController {
         
      lazy var tableView: UITableView = {
          
          let tableview = UITableView(frame: .zero, style: .grouped)
          tableview.delegate = self
          tableview.dataSource = self
          tableview.backgroundColor = .init(white: 0.9, alpha: 1)
          tableview.tableFooterView = UIView(frame: .zero)
          tableview.separatorStyle = .none
          tableview.alwaysBounceVertical = true
          tableview.translatesAutoresizingMaskIntoConstraints = false
          tableview.estimatedRowHeight = 120
          tableview.rowHeight = UITableView.automaticDimension

          return tableview
      }()
      
    var build: Build!
    var hardwares: [Hardware] = []
    
    init(withBuild build: Build) {
        super.init(nibName: nil, bundle: nil)
        
        self.build = build

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
      override func viewDidLoad() {
          super.viewDidLoad()

          // Do any additional setup after loading the view.
          self.title = "Build Details"
                  
          tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.cellID)
          tableView.register(HardwareTableViewCell.self, forCellReuseIdentifier: HardwareTableViewCell.cellID)
          
          self.view.addSubview(tableView)
        
          NotificationCenter.default.addObserver(self, selector: #selector(hardwaresUpdated(notification:)), name: NSNotification.Name(rawValue: kNotificationID_Hardware_Updated), object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(buildsUpdated(notification:)), name: NSNotification.Name(rawValue: kNotificationID_Build_Updated), object: nil)

          refreshTableView()
      }
      
      override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
          
          tableView.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: self.view.frame.size)
      }
      
    private func refreshTableView(){
        
        hardwares.removeAll()
        for hardwaderID in self.build.hardwares{
            if let hardw = HardwareManager.manager.getHardware(forFirID: hardwaderID){
                self.hardwares.append(hardw)
            }
        }
        
        tableView.reloadData()

    }
      
      @objc func hardwaresUpdated(notification: NSNotification){
          
          if let firID = notification.userInfo?[kNotification_UserInfoKey_Object_Updated_FIRID] as? String{
              print("Hardware updated with " + firID)
              
            var needsToRefresh = false
            for hardwaderID in self.build.hardwares{
                if hardwaderID == firID {
                    needsToRefresh = true
                }
            }
            
            if needsToRefresh {
                refreshTableView()
            }
            
          }
      }
      
      @objc func buildsUpdated(notification: NSNotification){
          
        if let firID = notification.userInfo?[kNotification_UserInfoKey_Object_Updated_FIRID] as? String, build.firID == firID{
            refreshTableView()
          }
      }
  }

extension BuildDetailsViewController: UITableViewDelegate,UITableViewDataSource{
      
    func numberOfSections(in tableView: UITableView) -> Int {
        return hardwares.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerHeight: CGFloat

        switch section {
        case 0:
            headerHeight = CGFloat.leastNonzeroMagnitude
        default:
            headerHeight = 0
        }

        return headerHeight
    
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .init(white: 0.9, alpha: 1)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: TableViewCell!

        guard indexPath.row >= 0, indexPath.row < hardwares.count else {
            
            cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.cellID) as? TableViewCell
            return cell
        }
        
        let obj = hardwares[indexPath.section]
        cell = tableView.dequeueReusableCell(withIdentifier: HardwareTableViewCell.cellID) as? HardwareTableViewCell
        
        cell.willDisplay(object: obj)

        return cell
    }
      
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
     
        guard let tCell = cell as? TableViewCell, let data = object(forIndexPath: indexPath) else {
            return
        }
        
        tCell.willDisplay(object: data)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tCell = cell as? TableViewCell else {
            return
        }
        
        tCell.didEndDisplay(object: nil)
    }
    
    private func object(forIndexPath indexPath: IndexPath) -> FIRObject?{
        
        if indexPath.section >= 0 && indexPath.section < hardwares.count{
            let data = hardwares[indexPath.section]
            return data
        }
        
        return nil
    }
}
