//
//  History+CoreDataProperties.swift
//  NewsFeedTask
//
//  Created by Rivile on 6/1/22.
//
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var title: String?
    @NSManaged public var imageDescription: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var date: String?
    @NSManaged public var image: Data?

}

extension History : Identifiable {

}
