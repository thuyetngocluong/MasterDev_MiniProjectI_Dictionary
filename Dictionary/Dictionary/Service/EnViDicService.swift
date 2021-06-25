//
//  EnViDicService.swift
//  Dictionary
//
//  Created by Luong Ngoc Thuyet on 6/22/21.
//  Copyright © 2021 thuyetln. All rights reserved.
//

import UIKit
import CoreData

typealias Success = (Bool) -> Void

class EnViDicService {
    let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

   
    private init() {
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.main.async {
            self.privateContext.parent = MainController.context
            group.leave()
        }
        group.wait()
    }
    
    static let shared = EnViDicService()
    
}
 
extension EnViDicService {
    func fetchData(sortDescriptors: [NSSortDescriptor], predicate: NSPredicate?, numberRecords: Int?) -> NSFetchedResultsController<EnVi> {
        let fetchRequest : NSFetchRequest<EnVi> = EnVi.fetchRequest()
        
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        if let limit = numberRecords { fetchRequest.fetchLimit = limit }
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest:                                                 fetchRequest,
                                                                  managedObjectContext: privateContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }

        return fetchedResultsController
    }

    func addWord(word: String, pronounce: String?, mean: String, note: String?, success: Success) {
        let entity = NSEntityDescription.entity(forEntityName: "EnVi", in: privateContext)!
      
        let enVi = EnVi(entity: entity, insertInto: privateContext)
       
       // set giá trị cho Object
        enVi.word = word
        enVi.pronounce = pronounce
        enVi.mean = mean
        enVi.note = note
        enVi.mark = true
        enVi.html = mean
        enVi.image = nil
       
       //save context
        self.save(success: success)
               
    }
    
    func save(success: Success) {
        do {
            try privateContext.save()
            privateContext.performAndWait {
                try! MainController.context.save()
            }
        } catch {
            success(false)
        }
        success(true)
    }
    
    func save() {
        do {
            try privateContext.save()
            privateContext.performAndWait {
                try! MainController.context.save()
            }
        } catch {}
    }
    
}
