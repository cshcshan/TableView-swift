//
//  CellInViewViewController.swift
//  TableView-swift
//
//  Created by Han Chen on 2019/9/4.
//  Copyright © 2019 cshan. All rights reserved.
//

import UIKit

class CellInViewViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.register(CellInViewTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
    }
}

extension CellInViewViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellInViewTableViewCell", for: indexPath) as! CellInViewTableViewCell
        cell.model = CellInViewModel(title: String(indexPath.row), desc: "HELLO")
        return cell
    }
}
