//
//  DevExamCell.swift
//  TestTaskAtsamazBitsoev
//
//  Created by Ацамаз on 16/02/2019.
//  Copyright © 2019 a.s.bitsoev. All rights reserved.
//

import UIKit

class DevExamCell: UITableViewCell {

    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var labDescribtion: UILabel!
    @IBOutlet weak var labDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
