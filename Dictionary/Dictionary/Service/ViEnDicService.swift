//
//  ViEnDicService.swift
//  Dictionary
//
//  Created by Luong Ngoc Thuyet on 6/24/21.
//  Copyright © 2021 thuyetln. All rights reserved.
//

import UIKit
import CoreData

class ViEnDicService {
    
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
    
    static let shared = ViEnDicService()
    
}

extension ViEnDicService {
    func fetchData(sortDescriptors: [NSSortDescriptor], predicate: NSPredicate?, numberRecords: Int?) -> NSFetchedResultsController<ViEn> {
        let fetchRequest : NSFetchRequest<ViEn> = ViEn.fetchRequest()
        
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
        } catch {
            print("fail")
        } 
    }
    
}

