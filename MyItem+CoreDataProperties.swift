//
//  MyItem+CoreDataProperties.swift
//  Five Shelves
//
//  Created by Kevin Ryan Nava on 6/3/20.
//  Copyright © 2020 Kevin Ryan Nava. All rights reserved.
//
//

import Foundation
import CoreData


extension MyItem {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<MyItem> {
        return NSFetchRequest<MyItem>(entityName: "MyItem")
    }

    @NSManaged public var shelfNumber: String
    @NSManaged public var itemName: String

}
