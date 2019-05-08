//
//  CombinedTableViewCell.swift
//  iJustSpent
//
//  Created by David New on 07/05/2019.
//  Copyright © 2019 David New. All rights reserved.
//

import UIKit

class CombinedTableViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var spending: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
