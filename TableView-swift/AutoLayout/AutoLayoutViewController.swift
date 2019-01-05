//
//  AutoLayoutViewController.swift
//  TableView-swift
//
//  Created by Han Chen on 2019/1/6.
//  Copyright © 2019 cshan. All rights reserved.
//

import Foundation
import UIKit

class AutoLayoutViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dataArray: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataArray()
        setupTableView()
    }
    
    private func setupDataArray() {
        dataArray = []
        for index in 0..<20 {
            var data: [String] = []
            data.append("\(index + 1)")
            var data1 = ""
            var data2 = ""
            for _ in 0..<index + 1 {
                data1 += "\(Int.random(in: 0..<1000))"
                data2 += "\(Int.random(in: 0..<1000))\n"
            }
            data.append("\(data1)")
            data.append("\(data2)")
            dataArray.append(data)
        }
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: String(describing: AutoLayoutTableViewCell.self), bundle: nil), forCellReuseIdentifier: "CELL")
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! AutoLayoutTableViewCell
        let data = dataArray[indexPath.row]
        cell.bind(one: data[0], two: data[1], three: data[2])
        return cell
    }
}
