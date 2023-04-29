//
//  AddingVC.swift
//  BookKeeper
//
//  Created by Vagan Galstian on 10.04.2023.
//

import UIKit

final class AddingVC: UIViewController {
    
    //MARK: - Properties
    private var addButton = UIButton()
    private var textField = UITextField()
    private var dataPicker = UIDatePicker()
    
    private var bookStore = Store()
    
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
    
    @objc func addBook() {
        guard let name = textField.text,
              !name.isEmpty,
              name != " " else {
            return
        }
        let rowDate = dataPicker.date
        let date = dateFormatter.string(from: rowDate)
        
        bookStore.addBook(book: Book(name: name, date: date))
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text,
           !text.isEmpty,
           text != " " {
            addButton.backgroundColor = .systemBlue
        }
    }
    
    @objc private func textFieldIsEmpty(_ textField: UITextField) {
        if let text = textField.text,
           text.isEmpty || text == " " {
            addButton.backgroundColor = .lightGray
        }
    }
    
    private func makeButtonActive() {
        addButton.backgroundColor = .systemBlue
    }
    
    //MARK: - Configuration
    private func addSubviews() {
        view.addSubview(textField)
        view.addSubview(dataPicker)
        view.addSubview(addButton)
    }
    
    private func prepareViews() {
        title = "Add new book"
        view.backgroundColor = .white
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        dataPicker.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        textField.placeholder = "Book name"
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.addTarget(self, action: #selector(textFieldIsEmpty(_:)), for: .editingChanged)
        
        dataPicker.datePickerMode = .date
        dataPicker.minimumDate = Date()
        dataPicker.maximumDate = Calendar.current.date(byAdding: .month, value: 3, to: Date())
        dataPicker.preferredDatePickerStyle = .wheels
        
        addButton.backgroundColor = .lightGray
        addButton.layer.cornerRadius = 10
        addButton.setTitle("Add", for: .normal)
        addButton.isEnabled = true
        addButton.titleLabel?.textColor = .white
        addButton.addTarget(self, action: #selector(addBook), for: .touchUpInside)
    }
    
    private func addConstraints() {
        addButtonBottomConstraint = addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            dataPicker.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            dataPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dataPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addButtonBottomConstraint
        ])
    }
}

//MARK: - Extensions
extension AddingVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
