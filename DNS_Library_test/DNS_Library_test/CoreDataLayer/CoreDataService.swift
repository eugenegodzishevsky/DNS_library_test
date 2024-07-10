//
//  CoreDataService.swift
//  DNS_Library_test
//
//  Created by Vermut xxx on 10.07.2024.
//

import CoreData

private enum Constants {
    static let containerName = "DNS_Library_test"
}

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.containerName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchBooks() -> [Book] {
        let request: NSFetchRequest<Book> = Book.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }
    
    func addBook(title: String, author: String, year: String) {
        let book = Book(context: context)
        book.title = title
        book.author = author
        book.year = year
        saveContext()
    }
    
    func updateBook(_ book: Book, title: String, author: String, year: String) {
        book.title = title
        book.author = author
        book.year = year
        saveContext()
    }
    
    func deleteBook(_ book: Book) {
        context.delete(book)
        saveContext()
    }
}
