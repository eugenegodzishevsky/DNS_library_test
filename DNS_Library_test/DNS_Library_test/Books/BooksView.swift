//
//  BooksView.swift
//  DNS_Library_test
//
//  Created by Vermut xxx on 10.07.2024.
//

import UIKit

private enum Constants {
    static let hasNoImplemented = "init(coder:) has not been implemented"
}

final class BookListView: UIView {
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.hasNoImplemented)
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(BooksTableViewCell.self, forCellReuseIdentifier: BooksTableViewCell.reuseIdentifier)
        
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tableView.backgroundColor = .systemBackground
    }
}
