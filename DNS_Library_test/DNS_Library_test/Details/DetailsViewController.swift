//
//  DetailsViewController.swift
//  DNS_Library_test
//
//  Created by Vermut xxx on 10.07.2024.
//

import UIKit

private enum Constants {
    static let edit = "Edit"
    static let error = "Error"
    static let ok = "OK"
    static let hasNoImplemented = "init(coder:) has not been implemented"
}

final class DetailsViewController: UIViewController, DetailsViewProtocol {
    private var presenter: DetailsPresenter!
    private let bookDetailView = DetailsView()
    private var book: Book?
    
    init(book: Book? = nil) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.hasNoImplemented)
    }
    
    override func loadView() {
        self.view = bookDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        bookDetailView.delegate = self
        setupKeyboardDismissRecognizer()
        
        presenter = DetailsPresenter(view: self, book: book)
        presenter.viewDidLoad()
    }
    
    func showBook(_ book: Book) {
        bookDetailView.titleTextField.text = book.title
        bookDetailView.authorTextField.text = book.author
        bookDetailView.yearTextField.text = book.year
        
        bookDetailView.saveButton.setTitle(Constants.edit, for: .normal)
    }
    
    func showError(_ error: String) {
        let alert = UIAlertController(title: Constants.error, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.ok, style: .default))
        present(alert, animated: true)
    }
    
    func dismiss() {
        navigationController?.popViewController(animated: true)
    }
}

extension DetailsViewController: DetailsViewDelegate {
    func didTapSaveButton(title: String, author: String, year: String) {
        presenter.saveBook(title: title, author: author, year: year)
    }
}
