//
//  TranslateController.swift
//  Dictionary
//
//  Created by Luong Ngoc Thuyet on 6/24/21.
//  Copyright © 2021 thuyetln. All rights reserved.
//

import UIKit

class TranslateController: UIViewController {
    
//    private var enViTranslator: Translator!
    
    @IBOutlet weak var srcTextView: UITextView!
    @IBOutlet weak var destTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        title = "Translate"
        alert()
        setupTranslator()
        setupTextView()
        setupFirebase()
    }
    
    private func alert() {
        let notification = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        notification.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
       
        notification.title = "Translation not complete"
        
        self.present(notification, animated: true, completion: nil)
    }
    
    private func setupTranslator() {
        DispatchQueue(label: "downloadTranslate").async {
           // Create an English-German translator:
//           let options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .german)
//           let envi = Translator.translator(options: options)
        }
    }
    
    private func setupTextView() {
        // src text view
        srcTextView.text = "Input to translate"
        srcTextView.textColor = UIColor.lightGray
        srcTextView.delegate = self
        srcTextView.layer.cornerRadius = 5
        
        // dest text view
        destTextView.layer.cornerRadius = 5
        destTextView.isEditable = false
    }
    
    private func setupFirebase() {
        // Create an En-Vi translator:
//        let options = TranslatorOptions(sourceLanguage: .en, targetLanguage: .vi)
//        enViTranslator = NaturalLanguage.naturalLanguage().translator(options: options)
    }

    @IBAction func enViTranslateAction(_ sender: Any) {
//        enViTranslator.translate(srcTextView.text) { translatedText, error in
//            guard error == nil else { return }
//            if let transTxt = translatedText {
//                self.destTextView.text = transTxt
//            }
//        }
    }
    
    
    @IBAction func viEnTranslateAction(_ sender: Any) {
    }
}

extension TranslateController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
    }
}
