//
//  BooksTableViewCell.swift
//  DNS_Library_test
//
//  Created by Vermut xxx on 10.07.2024.
//

import UIKit

private enum Constants {
    static let bookCell = "BookCell"
    static let hasNoImplemented = "init(coder:) has not been implemented"
}

final class BooksTableViewCell: UITableViewCell {
    static let reuseIdentifier = Constants.bookCell
    
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let yearLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.hasNoImplemented)
    }
    
    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, authorLabel, yearLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with book: Book) {
        titleLabel.text = "Title: \"\(book.title ?? "")\""
        authorLabel.text = "Author: \(book.author ?? "")"
        yearLabel.text = "Year: \(book.year ?? "")"
        self.selectionStyle = .none
    }
}
