//
//  SearchItemCell.swift
//  Dictionary
//
//  Created by Luong Ngoc Thuyet on 6/22/21.
//  Copyright © 2021 thuyetln. All rights reserved.
//

import UIKit

class SearchEnViCell: UITableViewCell {

    @IBOutlet weak var wordLB: UILabel!
    @IBOutlet weak var pronounceLB: UILabel!
    @IBOutlet weak var meanLB: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setItem(word: String, pronounce: String?, mean: String) {
        self.wordLB.text = word
        if let pro = pronounce {
            self.pronounceLB.text = "/\(pro)/"
        } else {
            self.pronounceLB.text = "//"
        }
        self.meanLB.text = mean
    }
    
}
