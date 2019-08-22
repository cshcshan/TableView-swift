//
//  LoadingCell.swift
//  EachCellLoading-swift
//
//  Created by Han Chen on 2016/6/11.
//  Copyright © 2016年 Han Chen. All rights reserved.
//

import Foundation
import UIKit

class LoadingCell: UITableViewCell {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var content_Label: UILabel!
    
    var count: Double = 0
    var timer: Timer!
    
    override func awakeFromNib() {
        activityIndicator.hidesWhenStopped = true
    }
    
    func bindUI() {
        count = Double(Int(arc4random_uniform(10)) + 1)
        activityIndicator.startAnimating()
        content_Label.text = "\(Int(count))"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
    }
    
    @objc func updateUI() {
        count -= 1
        if count <= 0 {
            if timer != nil {
                timer.invalidate()
                timer = nil
            }
            activityIndicator.stopAnimating()
        }
        content_Label.text = "\(Int(count))"
    }
}
