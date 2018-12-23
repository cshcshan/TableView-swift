//
//  MovingCellsViewController.swift
//  TableView-swift
//
//  Created by Han Chen on 2018/12/18.
//  Copyright © 2018 cshan. All rights reserved.
//

import UIKit

class MovingCellsViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    
    private var tableCount = 0
    private var data_dict: [Int: [String]] = [:]
    private var tableView_dict: [Int: UITableView] = [:]
    private var hasFakeCell: [Int: Bool] = [:] // if tableView doesn't have any cell, must put one fake cell
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupData()
        setupTableView()
    }
    
    private func setupData() {
        tableCount = Int.random(in: 2...3)
        print("Table Count: \(tableCount)")
        data_dict = [:]
        for index in 0..<tableCount {
            var data: [String] = []
            for i in 0..<3 * (index + 1) {
                data.append("\(String(describing: index + 1)) - \(String(describing: i + 1))")
            }
            hasFakeCell[index] = data.count == 0 ? true : false
            if data.count == 0 {
                data.append("")
            }
            data_dict[index] = data
        }
    }
    
    private func setupTableView() {
        for index in 0..<tableCount {
            let tableView = UITableView()
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
            tableView.addGestureRecognizer(longPress)
            stackView.addArrangedSubview(tableView)
            tableView_dict[index] = tableView
        }
    }
    
    @objc func handleLongPress(gesture: UIGestureRecognizer) {
        
        struct MovingCell {
            static var snapshot: UIView? = nil
            static var isAnimating: Bool = false
            static var needToShow: Bool = false
            static var toIndexPath: IndexPath? = nil
            static var offsetInCenterCursor = CGPoint.zero // record the offset from the location touched in self.view to the center of cell touched in self.view
        }
        struct From {
            static var tableView: UITableView? = nil
            static var tableViewIndex: Int = -1
            static var indexPath: IndexPath? = nil
        }
        struct To {
            static var tableView: UITableView? = nil
            static var tableViewIndex: Int = -1
            static var indexPath: IndexPath? = nil
        }
        
        let locationInView = gesture.location(in: view)

        switch gesture.state {
        case .began:
            // record the tableView touched, tableView's index in tableView_dict, and indexPath touched in tableView in From struct
            var cell: UITableViewCell?
            for index in 0..<tableCount {
                let tableView = tableView_dict[index]
                if tableView == gesture.view {
                    let location = gesture.location(in: tableView)
                    From.tableView = tableView
                    From.tableViewIndex = index
                    From.indexPath = tableView?.indexPathForRow(at: location)
                    cell = From.tableView!.cellForRow(at: From.indexPath!)
                    break
                }
            }
            guard From.tableView != nil else { return }
            guard hasFakeCell[From.tableViewIndex] == false else { return }
            // get the cell's center position in self.view
            let center = view.convert(cell!.center, from: From.tableView)
            // record snapshot of the cell touched, snapshot's center, and offset from cursor to center
            MovingCell.snapshot = snapshotOfCell(inputView: cell!)
            MovingCell.snapshot!.center = center
            MovingCell.snapshot!.alpha = 0.0
            MovingCell.offsetInCenterCursor = CGPoint(x: center.x - locationInView.x, y: center.y - locationInView.y)
            // add MovingCell.snapshot! to self.view
            view.addSubview(MovingCell.snapshot!)

            UIView.animate(withDuration: 0.25, animations: {
                MovingCell.snapshot!.center = center
                MovingCell.snapshot!.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
                MovingCell.snapshot!.alpha = 0.98
                MovingCell.isAnimating = true
                cell!.alpha = 0.0
            }, completion: { finished in
                guard finished else { return }
                MovingCell.isAnimating = false
                if MovingCell.needToShow {
                    MovingCell.needToShow = false
                    UIView.animate(withDuration: 0.25, animations: {
                        cell!.alpha = 1
                    })
                } else {
                    cell!.isHidden = true
                }
            })
        case .changed:
            guard hasFakeCell[From.tableViewIndex] == false else { return }
            
            // record the tableView moved to, tableView's index in tableView_dict, and indexPath moved to in tableView in From struct
            for index in 0..<tableCount {
                let tableView = tableView_dict[index]
                let location = gesture.location(in: tableView)
                let indexPath = tableView?.indexPathForRow(at: location)
                if indexPath != nil {
                    To.tableView = tableView
                    To.tableViewIndex = index
                    To.indexPath = indexPath
                    break
                }
            }
            
            guard MovingCell.snapshot != nil else { return }
            // set the new center to MovingCell.snapshot
            let center = CGPoint(x: locationInView.x + MovingCell.offsetInCenterCursor.x, y: locationInView.y + MovingCell.offsetInCenterCursor.y)
            MovingCell.snapshot!.center = center
            
            guard To.tableView != nil && To.indexPath != nil else { return }
            // remove and insert data in data_dict
            if From.indexPath!.row < data_dict[From.tableViewIndex]!.count {
                let fromString = data_dict[From.tableViewIndex]!.remove(at: From.indexPath!.row)
                data_dict[To.tableViewIndex]!.insert(fromString, at: To.indexPath!.row)
            }
            // remove and insert data in tableView
            if From.tableView == To.tableView {
                To.tableView?.moveRow(at: From.indexPath!, to: To.indexPath!)
            } else {
                From.tableView?.beginUpdates()
                From.tableView!.deleteRows(at: [From.indexPath!], with: .bottom)
                From.tableView?.endUpdates()
                To.tableView?.beginUpdates()
                To.tableView!.insertRows(at: [To.indexPath!], with: .bottom)
                To.tableView?.endUpdates()
                // deal with the fake cell
                var fromData = data_dict[From.tableViewIndex]!
                if fromData.count == 0 {
                    hasFakeCell[From.tableViewIndex] = true
                    fromData.append("")
                    data_dict[From.tableViewIndex] = fromData
                    From.tableView?.insertRows(at: [IndexPath(row: 0, section: 0)], with: .bottom)
                }
                var toData = data_dict[To.tableViewIndex]!
                if toData.count == 2 && hasFakeCell[To.tableViewIndex]! {
                    hasFakeCell[To.tableViewIndex] = false
                    let row = To.indexPath?.row == 0 ? 1 : 0
                    let indexPath = IndexPath(row: row, section: To.indexPath!.section)
                    toData.remove(at: row)
                    data_dict[To.tableViewIndex] = toData
                    To.tableView?.deleteRows(at: [indexPath], with: .bottom)
                }
            }
            
            From.tableView = To.tableView
            From.tableViewIndex = To.tableViewIndex
            From.indexPath = To.indexPath
        default:
            guard hasFakeCell[From.tableViewIndex] == false else { return }
            
            guard From.indexPath != nil else { return }
            let cell = From.tableView!.cellForRow(at: From.indexPath!)
            guard cell != nil else { return }
            if MovingCell.isAnimating {
                MovingCell.needToShow = true
            } else {
                cell!.isHidden = false
                cell!.alpha = 0.0
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                let center = CGPoint(x: locationInView.x + MovingCell.offsetInCenterCursor.x, y: locationInView.y + MovingCell.offsetInCenterCursor.y)
                MovingCell.snapshot!.center = center
                MovingCell.snapshot!.transform = CGAffineTransform.identity
                MovingCell.snapshot!.alpha = 0.0
                cell!.alpha = 1.0
            }, completion: { finished in
                guard finished else { return }
                From.indexPath = nil
                To.indexPath = nil
                MovingCell.snapshot!.removeFromSuperview()
                MovingCell.snapshot = nil
            })
        }
    }
    
    private func snapshotOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.frame.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let view: UIView = UIImageView(image: image)
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 0.0
        view.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.4
        return view
    }
}

extension MovingCellsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        for index in 0..<tableCount {
            if tableView == tableView_dict[index] {
                return data_dict[index]!.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var data: [String]!
        for index in 0..<tableCount {
            if tableView == tableView_dict[index] {
                data = data_dict[index]
                break
            }
        }
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

