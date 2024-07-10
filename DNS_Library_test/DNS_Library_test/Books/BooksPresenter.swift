//
//  BooksListPresenter.swift
//  DNS_Library_test
//
//  Created by Vermut xxx on 10.07.2024.
//

import Foundation

protocol BookListViewProtocol: AnyObject {
    func showBooks(_ books: [Book])
    func showError(_ error: String)
}

enum SortOption {
    case title
    case author
    case year
}

final class BooksPresenter {
    private weak var view: BookListViewProtocol?
    private let coreDataManager = CoreDataManager.shared
    private var books: [Book] = []
    private var filteredBooks: [Book] = []
    private var currentSortOption: SortOption = .title
    
    init(view: BookListViewProtocol) {
        self.view = view
    }
    
    func fetchBooks() {
        books = coreDataManager.fetchBooks()
        filteredBooks = books
        sortBooks(by: currentSortOption)
    }
    
    func addBook(title: String, author: String, year: String) {
        coreDataManager.addBook(title: title, author: author, year: year)
        fetchBooks()
    }
    
    func updateBook(_ book: Book, title: String, author: String, year: String) {
        coreDataManager.updateBook(book, title: title, author: author, year: year)
        fetchBooks()
    }
    
    func deleteBook(_ book: Book) {
        coreDataManager.deleteBook(book)
        fetchBooks()
    }
    
    func sortBooks(by option: SortOption) {
        currentSortOption = option
        switch option {
        case .title:
            filteredBooks.sort { $0.title ?? "" < $1.title ?? "" }
        case .author:
            filteredBooks.sort { $0.author ?? "" < $1.author ?? "" }
        case .year:
            filteredBooks.sort { $0.year ?? "" < $1.year ?? "" }
        }
        view?.showBooks(filteredBooks)
    }
    
    func filterBooks(with query: String) {
        if query.isEmpty {
            filteredBooks = books
        } else {
            filteredBooks = books.filter { book in
                return (book.title?.lowercased().contains(query.lowercased()) ?? false) ||
                (book.author?.lowercased().contains(query.lowercased()) ?? false) ||
                ("\(book.year ?? "")".contains(query))
            }
        }
        sortBooks(by: currentSortOption)
    }
}
