//
//  TableViewController.swift
//  BuildYourPC
//
//  Created by Beke Zoltán on 2020. 01. 27..
//  Copyright © 2020. Zoltán Beke. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {

    weak var tableView: UITableView!

    override func loadView() {
        super.loadView()

        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        [tableView].forEach { self.view.addSubview($0) }
//        self.view.addSubview(tableView)
        
//        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 10, left: 10, bottom: 10, right: 10))
        
        self.tableView = tableView
    }
}
