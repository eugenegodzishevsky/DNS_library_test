//
//  BooksViewController.swift
//  DNS_Library_test
//
//  Created by Vermut xxx on 10.07.2024.
//

import UIKit

private enum Constants {
    static let library = "Library"
    static let listBullet = "list.bullet"
    static let search = "Search Books"
    static let sort = "Sort by"
    static let title = "Title"
    static let author = "Author"
    static let year = "Year"
    static let cancel = "Cancel"
    static let error = "Error"
    static let ok = "OK"
    static let delete = "Delete"
}

final class BooksViewController: UIViewController, BookListViewProtocol {
    private var presenter: BooksPresenter!
    private var dataSource: UITableViewDiffableDataSource<Int, Book>!
    private var searchController = UISearchController()
    
    private let bookListView = BookListView()
    
    override func loadView() {
        self.view = bookListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        setupSearchController()
        setupKeyboardDismissRecognizer()
        
        presenter = BooksPresenter(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchBooks()
        bookListView.tableView.reloadData()
    }
    
    private func setupNavigationBar() {
        title = Constants.library
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add,
                            target: self,
                            action: #selector(addBook)),
            UIBarButtonItem(image: UIImage(systemName: Constants.listBullet),
                            style: .plain,
                            target: self,
                            action: #selector(showSortMenu))
        ]
        
        navigationItem.rightBarButtonItems?.forEach { $0.tintColor = .black }
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupTableView() {
        bookListView.tableView.delegate = self
        
        dataSource = UITableViewDiffableDataSource<Int, Book>(tableView: bookListView.tableView) { tableView, indexPath, book in
            let cell = tableView.dequeueReusableCell(withIdentifier: BooksTableViewCell.reuseIdentifier, for: indexPath) as! BooksTableViewCell
            cell.configure(with: book)
            return cell
        }
        
        bookListView.tableView.dataSource = dataSource
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.search
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    @objc private func addBook() {
        let detailViewController = DetailsViewController()
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    @objc private func showSortMenu() {
        let alert = UIAlertController(title: Constants.sort, message: nil, preferredStyle: .actionSheet)
                
        alert.addAction(UIAlertAction(title: Constants.title, style: .default) { _ in
            self.presenter.sortBooks(by: .title)
        })
        alert.addAction(UIAlertAction(title: Constants.author, style: .default) { _ in
            self.presenter.sortBooks(by: .author)
        })
        alert.addAction(UIAlertAction(title: Constants.year, style: .default) { _ in
            self.presenter.sortBooks(by: .year)
        })
        alert.addAction(UIAlertAction(title: Constants.cancel, style: .cancel))
        present(alert, animated: true)
    }
    
    func showBooks(_ books: [Book]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Book>()
        snapshot.appendSections([0])
        snapshot.appendItems(books)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func showError(_ error: String) {
        let alert = UIAlertController(title: Constants.error, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.ok, style: .default))
        present(alert, animated: true)
    }
}

extension BooksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let book = dataSource.itemIdentifier(for: indexPath) else { return }
        let detailViewController = DetailsViewController(book: book)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let book = dataSource.itemIdentifier(for: indexPath) else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: Constants.delete) { [weak self] (_, _, completionHandler) in
            self?.presenter.deleteBook(book)
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

extension BooksViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            presenter.filterBooks(with: searchText)
        }
    }
}

extension BooksViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.filterBooks(with: searchText)
    }
}

extension UIViewController {
    
    func setupKeyboardDismissRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
