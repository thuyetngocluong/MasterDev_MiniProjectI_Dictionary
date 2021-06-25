//
//  ViEn+CoreDataProperties.swift
//  Dictionary
//
//  Created by Luong Ngoc Thuyet on 6/21/21.
//  Copyright © 2021 thuyetln. All rights reserved.
//
//

import Foundation
import CoreData


extension ViEn {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ViEn> {
        return NSFetchRequest<ViEn>(entityName: "ViEn")
    }

    @NSManaged public var image: Data?
    @NSManaged public var note: String?
    @NSManaged public var mark: Bool
    @NSManaged public var html: String?
    @NSManaged public var mean: String
    @NSManaged public var pronounce: String?
    @NSManaged public var word: String

}
