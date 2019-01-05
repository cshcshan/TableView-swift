//
//  AutoLayoutTableViewCell.swift
//  TableView-swift
//
//  Created by Han Chen on 2019/1/6.
//  Copyright © 2019 cshan. All rights reserved.
//

import UIKit

class AutoLayoutTableViewCell: UITableViewCell {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(one: String, two: String, three: String) {
        label1.text = one
        label2.text = two
        label3.text = three
    }
}
