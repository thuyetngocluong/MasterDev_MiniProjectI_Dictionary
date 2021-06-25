//
//  SearchViEnCell.swift
//  Dictionary
//
//  Created by Luong Ngoc Thuyet on 6/24/21.
//  Copyright © 2021 thuyetln. All rights reserved.
//

import UIKit

class SearchViEnCell: UITableViewCell {

    @IBOutlet weak var wordLB: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setValue(word: String) {
        wordLB.text = word
    }
    
}
