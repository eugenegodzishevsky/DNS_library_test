//
//  DetailsView.swift
//  DNS_Library_test
//
//  Created by Vermut xxx on 10.07.2024.
//

import UIKit

private enum Constants {
    static let title = "Title"
    static let author = "Author"
    static let year = "Year"
    static let save = "Save"
    static let hasNoImplemented = "init(coder:) has not been implemented"
}

protocol DetailsViewDelegate: AnyObject {
    func didTapSaveButton(title: String, author: String, year: String)
}

final class DetailsView: UIView {
    let titleTextField = UITextField()
    let authorTextField = UITextField()
    let yearTextField = UITextField()
    let saveButton = UIButton()
    
    weak var delegate: DetailsViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.hasNoImplemented)
    }
    
    private func setupViews() {
        backgroundColor = .systemBackground
        
        [titleTextField, authorTextField, yearTextField].forEach { textField in
            textField.borderStyle = .roundedRect
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        
        titleTextField.placeholder = Constants.title
        authorTextField.placeholder = Constants.author
        yearTextField.placeholder = Constants.year
        yearTextField.keyboardType = .numberPad
        
        saveButton.setTitle(Constants.save, for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        saveButton.backgroundColor = .systemBlue
        saveButton.layer.cornerRadius = 10
        saveButton.clipsToBounds = true
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [titleTextField, authorTextField, yearTextField, saveButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func saveButtonTapped() {
        guard let title = titleTextField.text,
              let author = authorTextField.text,
              let year = yearTextField.text
        else { return }
        
        delegate?.didTapSaveButton(title: title, author: author, year: year)
    }
}
