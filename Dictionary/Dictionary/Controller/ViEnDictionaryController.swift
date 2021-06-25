//
//  ViEnDictionaryController.swift
//  Dictionary
//
//  Created by Luong Ngoc Thuyet on 6/24/21.
//  Copyright © 2021 thuyetln. All rights reserved.
//

import UIKit
import CoreData

class ViEnDictionaryController : UIViewController {
    
    private var fetchResultController: NSFetchedResultsController<ViEn>!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        title = "Từ điển Việt Anh"
        DispatchQueue(label: "fetchFirstData").async {
            self.fetchResultController = ViEnDicService.shared.fetchData(sortDescriptors: [], predicate: nil, numberRecords: nil)
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
    
        setupTableView()
        setupSearchBar()
        
    }
    
    private func setupTableView() {
        // config table view
        tableView.separatorColor = .black
        tableView.layer.cornerRadius = 5
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SearchViEnCell", bundle: nil), forCellReuseIdentifier: "ViEnDic")
    }
    
    private func setupSearchBar() {
        // config search bar
        searchBar.searchTextField.borderStyle = .none
        searchBar.searchTextField.tintColor = .gray
        searchBar.layer.cornerRadius = 5
        searchBar.delegate = self
    }
}


extension ViEnDictionaryController : UISearchBarDelegate {
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue(label: "SearchBar").async {
            var predicate: NSPredicate?
            if searchText != "" {
                predicate = NSPredicate(format: "word BEGINSWITH[c] %@", searchText)
            } else {
                predicate = nil
            }
            self.fetchResultController = ViEnDicService.shared.fetchData(sortDescriptors: [], predicate: predicate, numberRecords: 30)
            
            DispatchQueue.main.async { self.tableView.reloadData() }
       }
    }
}

extension ViEnDictionaryController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultController?.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aWord = fetchResultController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViEnDic", for: indexPath) as! SearchViEnCell
        cell.setValue(word: aWord.word)
        return cell
    }

}

extension ViEnDictionaryController : UITableViewDelegate {

    // MARK:  click cell table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        selectedWord = fetchResultController.object(at: indexPath)
//        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
}

