//
//  Book+CoreDataProperties.swift
//  DNS_Library_test
//
//  Created by Vermut xxx on 10.07.2024.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var year: String?

}

extension Book : Identifiable {}
