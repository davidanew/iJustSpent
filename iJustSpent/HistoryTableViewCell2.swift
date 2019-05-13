//
//  HistoryTableViewCell2.swift
//  iJustSpent
//
//  Created by David New on 27/04/2019.
//  Copyright © 2019 David New. All rights reserved.
//

import UIKit

@available(iOS, deprecated)
class HistoryTableViewCell2: UITableViewCell {

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
