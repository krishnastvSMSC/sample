//
//  WorkingHoursTableViewCell.swift
//  WifiConnection_Name
//
//  Created by SMSCountry Networks Pvt. Ltd on 01/11/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

class WorkingHoursTableViewCell: UITableViewCell {

    @IBOutlet weak var lblofInpunch: UILabel!
    @IBOutlet weak var lblofOutPunch: UILabel!
    @IBOutlet weak var lblofDuration: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
