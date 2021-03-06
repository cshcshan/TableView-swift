//
//  ViewController.swift
//  TableView-swift
//
//  Created by Han Chen on 2018/12/18.
//  Copyright © 2018 cshan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var data = ["Moving Cells", "AutoLayout", "Display Cell Animation", "Each Cell's Loading", "Cell in view"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "MovingCellsSegue", sender: nil)
        case 1:
            performSegue(withIdentifier: "AutoLayoutSegue", sender: nil)
        case 2:
            performSegue(withIdentifier: "DisplayCellsAnimationSegue", sender: nil)
        case 3:
            performSegue(withIdentifier: "EachCellsLoadingSegue", sender: nil)
        case 4:
            performSegue(withIdentifier: "CellInViewSegue", sender: nil)
        default: break
        }
    }
}

