//
//  YourWordController.swift
//  Dictionary
//
//  Created by Luong Ngoc Thuyet on 6/22/21.
//  Copyright © 2021 thuyetln. All rights reserved.
//

import UIKit
import CoreData

class YourWordController: UIViewController {
    
    private var fetchResultController: NSFetchedResultsController<EnVi>!
    var selectedWord: EnVi?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    private func initUI() {
        title = "Your Word"
        fetchAllWorld()
        navigationItem.backBarButtonItem = UIBarButtonItem (
                    title: "",
                    style: .plain,
                    target: self,
                    action: #selector(self.navigationController?.popViewController)
               )
        
        // config table view
        tableView.separatorColor = .black
        tableView.layer.cornerRadius = 5
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SearchYourWordCell", bundle: nil), forCellReuseIdentifier: "YourWord")
        
        // config search bar
        searchBar.searchTextField.borderStyle = .none
        searchBar.searchTextField.tintColor = .gray
        searchBar.layer.cornerRadius = 5
        searchBar.delegate = self
    }
    
    
    
    @IBAction func addNewWord(_ sender: UIBarButtonItem) {
        let addWordAlert = UIAlertController(title: "Add your word", message: nil, preferredStyle: .alert)
        addWordAlert.addTextField { textField in
            textField.placeholder = "Word"
        }
        addWordAlert.addTextField { textField in
            textField.placeholder = "Pronounce"
        }
        addWordAlert.addTextField { textField in
            textField.placeholder = "Mean"
        }
        addWordAlert.addTextField { textField in
            textField.placeholder = "Note"
        }
            
            
        addWordAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            [weak addWordAlert](_) in
            if let word = addWordAlert?.textFields?[0].text, let mean = addWordAlert?.textFields?[2].text, word.trimmingCharacters(in: .whitespaces) != "", mean.trimmingCharacters(in: .whitespaces) != "" {
                let pronounce = addWordAlert?.textFields?[1].text
                let note = addWordAlert?.textFields?[3].text
                DispatchQueue(label: "addWord").async {
                    EnViDicService.shared.addWord(word: word, pronounce: pronounce, mean: mean, note: note) { successful in
                        DispatchQueue.main.async {
                             let notification = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                             notification.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            
                             notification.title = successful ? "Update Successful" : "Update Fail"
                            if successful { self.fetchAllWorld() }
                             self.present(notification, animated: true, completion: nil)
                         }
                    }
                }
            } else {
                    let notification = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                    notification.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                   
                    notification.title = "Field Word and Mean cannot be blank!"
            
                    self.present(notification, animated: true, completion: nil)
                }
            
        }))
        addWordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(addWordAlert, animated: true, completion: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetail") {
            if let dest = segue.destination as? DetailWordController {
                dest.word = self.selectedWord
            }
        }
    }
    
    private func fetchAllWorld() {
        DispatchQueue(label: "fetchAllWord").async {
            self.fetchResultController = EnViDicService.shared.fetchData(sortDescriptors: [], predicate: NSPredicate(format: "mark == true"), numberRecords: nil)
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
    }
}

extension YourWordController : UISearchBarDelegate {
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue(label: "SearchBar").async {
            var predicate: NSPredicate?
            if searchText != "" {
                predicate = NSPredicate(format: "word BEGINSWITH[c] %@ AND mark == true", searchText)
            } else {
                predicate = NSPredicate(format: "mark == true", searchText)
            }
            self.fetchResultController = EnViDicService.shared.fetchData(sortDescriptors: [], predicate: predicate, numberRecords: 6)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
       }
    }
}

extension YourWordController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultController?.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aWord = fetchResultController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "YourWord", for: indexPath) as! SearchYourWordCell
        cell.setValue(word: aWord)
        return cell
    }

}

extension YourWordController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedWord = fetchResultController.object(at: indexPath)
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
}

