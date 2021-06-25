//
//  EnVi+CoreDataProperties.swift
//  Dictionary
//
//  Created by Luong Ngoc Thuyet on 6/21/21.
//  Copyright © 2021 thuyetln. All rights reserved.
//
//

import Foundation
import CoreData


extension EnVi {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EnVi> {
        return NSFetchRequest<EnVi>(entityName: "EnVi")
    }

    @NSManaged public var image: Data?
    @NSManaged public var note: String?
    @NSManaged public var mean: String
    @NSManaged public var pronounce: String?
    @NSManaged public var html: String?
    @NSManaged public var word: String
    @NSManaged public var mark: Bool

}
