//
//  SearchYourWordCell.swift
//  Dictionary
//
//  Created by Luong Ngoc Thuyet on 6/22/21.
//  Copyright © 2021 thuyetln. All rights reserved.
//

import UIKit

class SearchYourWordCell: UITableViewCell {

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
    
    func setValue(word: EnVi) {
        wordLB.text = word.word
        if let pro = word.pronounce {
            self.pronounceLB.text = "/\(pro)/"
        } else {
            self.pronounceLB.text = "//"
        }
        meanLB.text = word.mean
    }
}
