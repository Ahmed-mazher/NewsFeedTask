//
//  StockL+CoreDataProperties.swift
//  NewsFeedTask
//
//  Created by Rivile on 6/1/22.
//
//

import Foundation
import CoreData


extension StockL {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StockL> {
        return NSFetchRequest<StockL>(entityName: "StockL")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: Double

}

extension StockL : Identifiable {

}
