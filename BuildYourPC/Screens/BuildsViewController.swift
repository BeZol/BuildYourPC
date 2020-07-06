//
//  BuildsViewController.swift
//  BuildYourPC
//
//  Created by Beke Zoltán on 2020. 01. 24..
//  Copyright © 2020. Zoltán Beke. All rights reserved.
//

import UIKit

class BuildsViewController: ContentViewController {
    
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
    
//    lazy var coverView: UIView = {
//
//        let coverView = UIView(frame: .zero)
//        coverView.backgroundColor = .green
//        coverView.translatesAutoresizingMaskIntoConstraints = false
//
//        return coverView
//    }()
    
    var hardwares: Array<Hardware> = []
    var builds: Array<Build> = []
    
    var tableViewData: Array<FIRObject>{
        get{
            return builds
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        self.title = "Builds"
                
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.cellID)
        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: InfoTableViewCell.cellID)
        tableView.register(BuildTableViewCell.self, forCellReuseIdentifier: BuildTableViewCell.cellID)
        tableView.register(HardwareTableViewCell.self, forCellReuseIdentifier: HardwareTableViewCell.cellID)

        
        
        self.view.addSubview(tableView)

        
        NotificationCenter.default.addObserver(self, selector: #selector(hardwaresUpdated(notification:)), name: NSNotification.Name(rawValue: kNotificationID_Hardware_Updated), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(buildsUpdated(notification:)), name: NSNotification.Name(rawValue: kNotificationID_Build_Updated), object: nil)

        FirestoreManager.manager.downloadAllData(atCollectionReference: FirestoreManager.manager.getDatabaseCollectionReference(byType: .Hardwares), addListener: true, withObjectMapper: HardwareManager.manager) { (error) in

            guard let hardwares = HardwareManager.manager.getHardwares() else{
                return
            }

            self.hardwares = hardwares
            self.tableView.reloadData()
        }
        
        FirestoreManager.manager.downloadAllData(atCollectionReference: FirestoreManager.manager.getDatabaseCollectionReference(byType: .Builds), addListener: true, withObjectMapper: BuildManager.manager) { (error) in
            
            guard let builds = BuildManager.manager.getBuilds() else{
                return
            }
            
            print("")
            self.builds = builds
            self.tableView.reloadData()

        }
        
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let safeAreaTop = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
//
//        let magicalSafeAreaTop: CGFloat = safeAreaTop + (navigationController?.navigationBar.frame.height ?? 0)
//        let offset = scrollView.contentOffset.y + magicalSafeAreaTop
        
//        let alpha: CGFloat = 1 - ((scrollView.contentOffset.y + magicalSafeAreaTop) / magicalSafeAreaTop)
//
//        [tableView].forEach{$0.alpha = alpha}
//
//        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: self.view.frame.size)
    }
    
    @objc func hardwaresUpdated(notification: NSNotification){
        
        if let firID = notification.userInfo?[kNotification_UserInfoKey_Object_Updated_FIRID] as? String{
            print("Hardware updated with " + firID)
            
            self.tableView.reloadData()

            let updatedHardware = HardwareManager.manager.getHardware(forFirID: firID)
            print(updatedHardware?.name as Any)
            
            
//            self.btn.setTitle(updatedHardware?.name, for: .normal)
        }
    }
    
    @objc func buildsUpdated(notification: NSNotification){
        
        if let firID = notification.userInfo?[kNotification_UserInfoKey_Object_Updated_FIRID] as? String{
            print("Build updated with " + firID)
            
            self.tableView.reloadData()

            let updatedBuild = BuildManager.manager.getBuild(forFirID: firID)
            print(updatedBuild?.name as Any)
            
        }
    }
}

extension BuildsViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
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

        guard indexPath.row >= 0, indexPath.row < tableViewData.count else {
            
            cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.cellID) as? TableViewCell
            return cell
        }
        
        let obj = tableViewData[indexPath.section]
        if obj is Hardware{
            cell = tableView.dequeueReusableCell(withIdentifier: HardwareTableViewCell.cellID) as? HardwareTableViewCell
        }
        else if obj is Build{
            cell = tableView.dequeueReusableCell(withIdentifier: BuildTableViewCell.cellID) as? BuildTableViewCell
        }
        else{
            cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.cellID) as? TableViewCell
            return cell
        }
        
        cell.willDisplay(object: obj)
//        cell.layoutIfNeeded()

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let data = object(forIndexPath: indexPath) as? Build{
            let vc = BuildDetailsViewController(withBuild: data)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    private func object(forIndexPath indexPath: IndexPath) -> FIRObject?{
        
        if indexPath.section >= 0 && indexPath.section < tableViewData.count{
            let data = tableViewData[indexPath.section]
            return data
        }
        
        return nil
    }
        
}
