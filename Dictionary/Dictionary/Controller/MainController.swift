//
//  ViewController.swift
//  Dictionary
//
//  Created by Luong Ngoc Thuyet on 6/21/21.
//  Copyright © 2021 thuyetln. All rights reserved.
//

import UIKit
import CoreData

class MainController: UIViewController {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let dispatchGroup: DispatchGroup = DispatchGroup()
    
    private var fetchResultController: NSFetchedResultsController<EnVi>!
    var selectedWord: EnVi?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var viEnDicView: UIView!
    @IBOutlet weak var translateView: UIView!
    @IBOutlet weak var yourWordView: UIView!
    @IBOutlet weak var searchTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        initUI()
    }
    
    private func initUI() {
        DispatchQueue(label: "fetchFirstData").async {
            self.fetchResultController = EnViDicService.shared.fetchData(sortDescriptors: [], predicate: nil, numberRecords: 0)
        }
            
        
        title = "Dictionary"
        
        navigationItem.backBarButtonItem = UIBarButtonItem (
             title: "",
             style: .plain,
             target: self,
             action: #selector(self.navigationController?.popViewController)
        )
        
        setupViewContent()
        setupTableView()
        setupSearchBar()
    }
    
    private func setupViewContent() {
        viEnDicView.layer.cornerRadius = 5
        viEnDicView.setOnClickListener {
           self.performSegue(withIdentifier: "viEnDic", sender: nil)
        }
       
        translateView.layer.cornerRadius = 5
        translateView.setOnClickListener {
           self.performSegue(withIdentifier: "mainToTranslate", sender: nil)
        }
       
        yourWordView.layer.cornerRadius = 5
        yourWordView.setOnClickListener {
           self.performSegue(withIdentifier: "showYourWord", sender: nil)
        }
    }
    
    private func setupTableView() {
        // config table view
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(UINib(nibName: "SearchEnViCell", bundle: nil), forCellReuseIdentifier: "SearchItem")
        searchTableView.separatorColor = UIColor.white
        searchTableView.isHidden = true
        searchTableView.layer.cornerRadius = 5
    }
    
    private func setupSearchBar() {
        // config search bar
        searchBar.delegate = self
        searchBar.searchTextField.borderStyle = .none
        searchBar.searchTextField.tintColor = .gray
        searchBar.layer.cornerRadius = 5
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if (segue.identifier == "showDetail") {
               if let dest = segue.destination as? DetailWordController {
                   dest.word = self.selectedWord
               }
           }
       }
}



extension MainController : UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue(label: "SearchBar").async {
            let predicate = NSPredicate(format: "word BEGINSWITH[c] %@", searchText)
            self.fetchResultController = EnViDicService.shared.fetchData(sortDescriptors: [], predicate: predicate, numberRecords: 6)
            DispatchQueue.main.async {
                if let count = self.fetchResultController.fetchedObjects?.count {
                    self.searchTableView.isHidden = count == 0
                } else {
                    self.searchTableView.isHidden = true
                }
                self.searchTableView.reloadData()
            }
        }
    }
    
}


extension MainController : UITableViewDataSource {
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

extension MainController : UITableViewDelegate {

    // MARK:  click cell table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedWord = fetchResultController.object(at: indexPath)
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
}



