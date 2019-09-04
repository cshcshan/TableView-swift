//
//  CellInViewTableViewCell.swift
//  TableView-swift
//
//  Created by Han Chen on 2019/9/4.
//  Copyright © 2019 cshan. All rights reserved.
//

import UIKit

struct CellInViewModel {
    var title: String
    var desc: String
    
    init(title: String, desc: String) {
        self.title = title
        self.desc = desc
    }
}

class CellInViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var model: CellInViewModel? {
        didSet {
            self.configureCell()
        }
    }
    
    private func configureCell() {
        titleLabel.text = model?.title
        descLabel.text = model?.desc
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
