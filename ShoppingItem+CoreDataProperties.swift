//
//  ShoppingItem+CoreDataProperties.swift
//  ShoppingList
//
//  Created by Tony on 01/04/2017.
//  Copyright © 2017 Tony. All rights reserved.
//

import Foundation
import CoreData


extension ShoppingItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShoppingItem> {
        return NSFetchRequest<ShoppingItem>(entityName: "ShoppingItem");
    }

    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var quantity: Int32

}
