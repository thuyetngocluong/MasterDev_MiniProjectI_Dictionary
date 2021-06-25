//
//  DetailWordController.swift
//  Dictionary
//
//  Created by Luong Ngoc Thuyet on 6/21/21.
//  Copyright © 2021 thuyetln. All rights reserved.
//

import UIKit
import CoreData

class DetailWordController: UIViewController {
    var selectedWord: EnVi?
    var word: EnVi?
    var selectedPos = 0
    let selectedColor = UIColor(red: 75/255, green: 122/255, blue: 161/255, alpha: 1)
    var lbs: [UILabel] = []
    var botViews: [UIView] = []
    var isSearching = false
    var imagePicker = UIImagePickerController()
    private var fetchResultController: NSFetchedResultsController<EnVi>!
    
    // navigation bar button
    @IBOutlet weak var starIcon: UIBarButtonItem!
    
    // content of En-Vi utilitiy
    @IBOutlet weak var enViTextView: UITextView!
    
    // content of Note utilitiy
    @IBOutlet weak var noteTextView: UITextView!
    
    // content of Image utilitiy
    @IBOutlet weak var imageView: UIImageView!
    
    // option of Image utilitiy
    @IBOutlet weak var saveImageBtn: UIButton!
    @IBOutlet weak var changeImageBtn: UIButton!
    @IBOutlet weak var cancelImageBtn: UIButton!
    
    // stack view contains option of Image utilitiy
    @IBOutlet weak var optionImageStackView: UIStackView!
    
    // general alert
    @IBOutlet weak var alertLabel: UILabel!
    
    // label of utilities
    @IBOutlet weak var enViLB: UILabel!
    @IBOutlet weak var noteLB: UILabel!
    @IBOutlet weak var imageLB: UILabel!
    
    // mark of label of utilities
    @IBOutlet weak var enViBottomView: UIView!
    @IBOutlet weak var imageBottomView: UIView!
    @IBOutlet weak var noteBottomView: UIView!
    

    // stackView label and mark of utilities
    @IBOutlet weak var enViStackView: UIStackView!
    @IBOutlet weak var imageStackView: UIStackView!
    @IBOutlet weak var noteStackView: UIStackView!
    
    // search tool
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // constraint
    @IBOutlet weak var constraintTopSearchBar: NSLayoutConstraint!
    @IBOutlet weak var constraintToBotSearchBar: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightSearchBar: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        lbs = [enViLB, noteLB, imageLB]
        botViews = [enViBottomView, noteBottomView, imageBottomView]
        
        DispatchQueue(label: "fetchFirstData").async {
            self.fetchResultController = EnViDicService.shared.fetchData(sortDescriptors: [], predicate: nil, numberRecords: 0)
        }
        
        
        navigationItem.backBarButtonItem = UIBarButtonItem (
                    title: "",
                    style: .plain,
                    target: self,
                    action: #selector(self.navigationController?.popViewController)
               )
        setupSearchBar()
        
        setupTableView()
        
        setupSearchTool()
        
        setupFirstData()
        
        setupClickAction()
        
        setupSwipeGesture()
    }
    
    // MARK: Set up all UI
    
    private func setupSearchTool() {
        if isSearching {
           searchBar.isHidden = false
           constraintTopSearchBar.constant = 20
           constraintToBotSearchBar.constant = 20
           constraintHeightSearchBar.constant = 50
           tableView.isHidden = true
        } else {
            searchBar.isHidden = true
            constraintTopSearchBar.constant = 0
            constraintToBotSearchBar.constant = 0
            constraintHeightSearchBar.constant = 0
            tableView.isHidden = true
        }
    }
    
    private func setupFirstData() {
        focusLB(pos: selectedPos)
        enViTextView.isEditable = false
        noteTextView.isEditable = false
        if let w = word {
            title = w.word
            starIcon.image = w.mark ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
            onChangeEnViView()
            onChangeNoteView()
            onChangeImageView()
        }
    }
    
    private func setupSwipeGesture() {
        // set swipe gesture
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))

        leftSwipe.direction = .left
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    private func setupClickAction() {
        // set on click view
        enViStackView.setOnClickListener { self.focusLB(pos: 0) }
        noteStackView.setOnClickListener { self.focusLB(pos: 1) }
        imageStackView.setOnClickListener { self.focusLB(pos: 2) }
    }
    
    
    private func setupTableView() {
        // config table view
       tableView.delegate = self
       tableView.dataSource = self
       tableView.register(UINib(nibName: "SearchEnViCell", bundle: nil), forCellReuseIdentifier: "SearchItem")
       tableView.separatorColor = UIColor.white
       tableView.isHidden = true
       tableView.layer.cornerRadius = 5
    }
    
    private func setupSearchBar() {
        // config search bar
        searchBar.delegate = self
        searchBar.searchTextField.borderStyle = .none
        searchBar.searchTextField.tintColor = .gray
        searchBar.layer.cornerRadius = 5
    }
    
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
           if let swipeGesture = gesture as? UISwipeGestureRecognizer {
               switch swipeGesture.direction {
                   case .right:
                       focusLB(pos: (selectedPos + 1) % 3)
                   case .left:
                       focusLB(pos: (3 + selectedPos - 1) % 3)
                   default:
                       break
               }
           }
       }
    
    // MARK: Update view when has changed
    private func onChangeEnViView() {
        if let html = word?.html {
            DispatchQueue(label: "changeEnViTxt").async {
                let html = "<style>body{font-size: 22px;}</style>\(html)".htmlToAttributedString
                DispatchQueue.main.async { self.enViTextView.attributedText = html }
            }
        } else {
            alertLabel.text = "No Description"
        }
    }
    
    private func onChangeNoteView() {
        if let note = word?.note {
            noteTextView.text = note
        } else {
            alertLabel.text = "No Note"
        }
    }
    
    private func onChangeImageView() {
        if let img = word?.image {
            DispatchQueue(label: "changeImage").async {
                let uiImg = UIImage(data: img)
                DispatchQueue.main.async { self.imageView.image = uiImg }
            }
        }
    }
    
    
    // MARK: Show view
    private func showEnViView() {
        noteTextView.isHidden = true
        imageView.isHidden = true
        optionImageStackView.isHidden = true
        if let _ = word?.html {
            alertLabel.isHidden = true
            enViTextView.isHidden = false
        } else {
            enViTextView.isHidden = true
            alertLabel.isHidden = false
            alertLabel.text = "No Description"
        }
    }
    
    private func showNoteView() {
        enViTextView.isHidden = true
        imageView.isHidden = true
        optionImageStackView.isHidden = true
        if let _ = word?.note {
            noteTextView.isHidden = false
            alertLabel.isHidden = true
        } else {
            alertLabel.text = "No Note"
            alertLabel.isHidden = false
            noteTextView.isHidden = true
        }
    }
    
    private func showImageView() {
        noteTextView.isHidden = true
        enViTextView.isHidden = true
        optionImageStackView.isHidden = false
       
        if let _ = word?.image {
            alertLabel.isHidden = true
            imageView.isHidden = false
        } else {
            imageView.isHidden = true
            alertLabel.isHidden = false
            alertLabel.text = "No Image"
        }
    }
    
    // change focus bettween label
    private func focusLB(pos: Int) {
        selectedPos = pos
        lbs.forEach { lb in lb.textColor = .gray }
        botViews.forEach { v in v.alpha = 0 }
        
        lbs[selectedPos].textColor = selectedColor
        botViews[selectedPos].alpha = 1
        
        switch selectedPos {
        case 0:
            showEnViView()
        case 1:
            showNoteView()
        case 2:
            showImageView()
        default:
            break
        }
    }
    
    // MARK: Action of button
    // click search icon
    @IBAction func searchAction(_ sender: UIBarButtonItem) {
        isSearching = !isSearching
        setupSearchTool()
    }
    
    // click star icon
    @IBAction func markWord(_ sender: UIBarButtonItem) {
        if let w = word {
            w.mark = !w.mark
            starIcon.image = w.mark ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
            EnViDicService.shared.save()
        }
    }
    
    // click pencil icon
    @IBAction func editNoteAction(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Change your note", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            if let note = self.word?.note {
                textField.text = note
            } else {
                textField.placeholder = "Input your note here"
            }
        }
        
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            [weak alert](_) in
            if let tf = alert?.textFields?[0].text {
                self.word?.note = tf
                DispatchQueue(label: "saveNote").async {
                    EnViDicService.shared.save { successful in
                       DispatchQueue.main.async {
                            let notification = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                            notification.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                           
                            notification.title = successful ? "Update Successful" : "Update Fail"
                            if successful { self.onChangeNoteView() }
                            self.present(notification, animated: true, completion: nil)
                        }
                   }
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // click button save
    @IBAction func onSaveImage(_ sender: UIButton) {
        self.word?.image = self.imageView.image?.pngData()
        DispatchQueue(label: "saveImage").async {
            EnViDicService.shared.save { successful in
                DispatchQueue.main.async {
                    let notification = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                    notification.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                   
                    notification.title = successful ? "Update Successful" : "Update Fail"
                    if successful { self.onChangeImageView() }
                    self.present(notification, animated: true, completion: nil)
                }
            }
        }
    }
    
    //click button change
    @IBAction func onChangeImage(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
           imagePicker.delegate = self
           imagePicker.sourceType = .photoLibrary
           imagePicker.allowsEditing = false

           present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // click button cancel
    @IBAction func onCancelSaveImage(_ sender: Any) {
        if let img = word?.image {
           DispatchQueue(label: "changeImage").async {
               let uiImg = UIImage(data: img)
               DispatchQueue.main.async { self.imageView.image = uiImg }
           }
        } else {
            self.imageView.image = nil
        }
    }
}

extension DetailWordController : UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue(label: "SearchBar").async {
            let predicate = NSPredicate(format: "word BEGINSWITH[c] %@", searchText)
            self.fetchResultController = EnViDicService.shared.fetchData(sortDescriptors: [], predicate: predicate, numberRecords: 6)
            DispatchQueue.main.async {
                if let count = self.fetchResultController.fetchedObjects?.count {
                        self.tableView.isHidden = count == 0
                    } else {
                        self.tableView.isHidden = true
                    }
                    self.tableView.reloadData()
            }
        }
    }
    
}


extension DetailWordController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultController?.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aWord = fetchResultController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchItem", for: indexPath) as! SearchEnViCell
        cell.setItem(word: aWord.word, pronounce: aWord.pronounce, mean: aWord.mean)
        return cell
    }

}

extension DetailWordController : UITableViewDelegate {

    // MARK:  click cell table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedWord = fetchResultController.object(at: indexPath)
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "DetailWordController") as! DetailWordController
        vc.word = selectedWord
        self.navigationController!.pushViewController(vc, animated: true)
    }
}

extension DetailWordController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        alertLabel.isHidden = true
        imageView.isHidden = false
        if let editedImage = info[.editedImage] as? UIImage {
            imageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageView.image = originalImage
        }
      
        self.dismiss(animated: true)
    }
}

