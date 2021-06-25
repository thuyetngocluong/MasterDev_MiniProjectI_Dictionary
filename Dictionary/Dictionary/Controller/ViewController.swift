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
    var fetchedResultsController: NSFetchedResultsController<ViEn>!
    
  
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var vieww: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        title = "Dictionary"
       
        vieww.setOnClickListener {
            self.performSegue(withIdentifier: "showDetail", sender: nil)
        }
        
        searchBar.delegate = self
        
    }
}


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

extension MainController : UISearchBarDelegate {
    
}

//extension ViewController : UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return fetchedResultsController.fetchedObjects!.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Dic", for: indexPath) as! TableViewCell
//        let aWord = fetchedResultsController.object(at: indexPath)
//        cell.setValue(label: aWord.word)
//        return cell
//
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//
//            // lấy item ra để xoá
//            let user = fetchedResultsController.object(at: indexPath)
//
//            // delete
//            context.delete(user)
//
//            //save context
//            do {
//                try context.save()
//            } catch let error as NSError {
//                print("Could not save. \(error), \(error.userInfo)")
//            }
//        }
//    }
//
//}
//
//extension ViewController : UITableViewDelegate {
//
//    // MARK:  click cell table
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let aWord = fetchedResultsController.object(at: indexPath)
//
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//}
//
//extension ViewController : NSFetchedResultsControllerDelegate {
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch (type) {
//        case .insert:
//            print("insert")
//            if let i = newIndexPath {
//
//                tableView.insertRows(at: [i], with: .fade)
//            }
//            break;
//        case .delete:
//            print("delete")
//            if let i = indexPath {
//                tableView.deleteRows(at: [i], with: .fade)
//            }
//            break;
//        case .update:
//            print("update")
//            tableView.reloadRows(at: [indexPath!], with: .automatic)
//            break;
//        default:
//            print("default")
//        }
//    }
//}



