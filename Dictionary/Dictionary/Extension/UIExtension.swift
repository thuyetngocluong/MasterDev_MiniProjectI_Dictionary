//
//  UiExtension.swift
//  Dictionary
//
//  Created by Luong Ngoc Thuyet on 6/23/21.
//  Copyright © 2021 thuyetln. All rights reserved.
//

import UIKit
// MARK: UIView Extension
extension UIView {
    class ClickListener: UITapGestureRecognizer {
        var onClick : (() -> Void)? = nil
    }
    
    func setOnClickListener(action :@escaping () -> Void) {
        let tapRecogniser = ClickListener(target: self, action: #selector(onViewClicked(sender:)))
        tapRecogniser.onClick = action
        self.addGestureRecognizer(tapRecogniser)
    }

    @objc func onViewClicked(sender: ClickListener) {
        if let onClick = sender.onClick {
            onClick()
        }
    }
  
}
