//
//  EachCellLoadingViewController.swift
//  TableView-swift
//
//  Created by Han Chen on 2019/8/22.
//  Copyright © 2019 cshan. All rights reserved.
//

import UIKit

class EachCellLoadingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - constant
    let LOADINGCELL_NIB_NAME = String(describing: LoadingCell.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: LOADINGCELL_NIB_NAME, bundle: nil), forCellReuseIdentifier: LOADINGCELL_NIB_NAME)
        tableView.dataSource = self
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        tableView.reloadData()
    }
}

extension EachCellLoadingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LOADINGCELL_NIB_NAME, for: indexPath) as! LoadingCell
        cell.bindUI()
        return cell
    }
}
