//
//  DetailsPresenter.swift
//  DNS_Library_test
//
//  Created by Vermut xxx on 10.07.2024.
//

import Foundation

protocol DetailsViewProtocol: AnyObject {
    func showBook(_ book: Book)
    func showError(_ error: String)
    func dismiss()
}

final class DetailsPresenter {
    private weak var view: DetailsViewProtocol?
    private let coreDataManager = CoreDataManager.shared
    private var book: Book?
    
    init(view: DetailsViewProtocol, book: Book? = nil) {
        self.view = view
        self.book = book
    }
    
    func viewDidLoad() {
        if let book = book {
            view?.showBook(book)
        }
    }
    
    func saveBook(title: String, author: String, year: String) {
        if let book = book {
            coreDataManager.updateBook(book, title: title, author: author, year: year)
        } else {
            coreDataManager.addBook(title: title, author: author, year: year)
        }
        view?.dismiss()
    }
}

