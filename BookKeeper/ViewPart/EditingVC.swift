//
//  EditingVC.swift
//  BookKeeper
//
//  Created by Vagan Galstian on 10.04.2023.
//

import UIKit

final class EditingVC: UIViewController {
    
    //MARK: - Properties
    private var addButton = UIButton()
    private var textField = UITextField()
    private var datePicker = UIDatePicker()
    
    private var bookStore = Store()
    var booksViewController = BooksVC()
    
    private var addButtonBottomConstraint: NSLayoutConstraint!
    
    private lazy var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yy"
            return formatter
        }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        prepareViews()
        addConstraints()
        
        textField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK: - Methods
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardSize.cgRectValue.height
        
        addButtonBottomConstraint.constant = -keyboardHeight - 20
        view.layoutIfNeeded()
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        addButtonBottomConstraint.constant = -60
        view.layoutIfNeeded()
    }
    
    @objc private func editButtonPressed() {
        guard let name = textField.text,
              !name.isEmpty,
              name != " " else {
            return
        }
        let rowDate = datePicker.date
        let stringDate = dateToString(date: rowDate)
        bookStore.books[booksViewController.selectedBookNumber].name = name
        bookStore.books[booksViewController.selectedBookNumber].date = stringDate
        navigationController?.popViewController(animated: true)
    }
    
    private func stringToDate(date: String) -> Date {
        let newDate = dateFormatter.date(from: date) ?? Date()
        return newDate
    }
    
    private func dateToString(date: Date) -> String {
        let date = dateFormatter.string(from: date)
        return date
    }
    
    //MARK: - Configuration
    private func addSubviews() {
        view.addSubview(textField)
        view.addSubview(datePicker)
        view.addSubview(addButton)
    }
    
    private func prepareViews() {
        let bookNumber = self.booksViewController.selectedBookNumber
        
        title = "Edit info"
        view.backgroundColor = .white
        
        textField.text = bookStore.books[bookNumber].name
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        datePicker.datePickerMode = .date
        datePicker.date = stringToDate(date: bookStore.books[bookNumber].date)
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Calendar.current.date(byAdding: .month, value: 3, to: Date())
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        addButton.backgroundColor = .systemBlue
        addButton.layer.cornerRadius = 10
        addButton.setTitle("Edit", for: .normal)
        addButton.titleLabel?.textColor = .white
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
    }
    
    private func addConstraints() {
        addButtonBottomConstraint = addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            datePicker.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addButtonBottomConstraint
        ])
    }
}

//MARK: - Extensions
extension EditingVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
