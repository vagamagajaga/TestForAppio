//
//  BooksVC.swift
//  BookKeeper
//
//  Created by Vagan Galstian on 09.04.2023.
//

import UIKit

final class BooksVC: UIViewController {
    
    //MARK: - Properties
    private var tableView = UITableView()
    private var addButton = UIButton()
    private var filterButton  = UIButton()
    private var emptyTextLabel = UILabel()
    
    private var bookStore = Store()
    
    private let reusedCell = "reusedCell"
    private var isFilteredByName: Bool = true
    lazy var selectedBookNumber = 0
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        prepareViews()
        addSubviews()
        addConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        isFilteredByName ? updateBooksByName() : updateBooksByDate()
        isTableEmpty()
        tableView.reloadData()
    }

    //MARK: - Methods
    @objc private func addButtonPressed() {
        let vc = AddingVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func filterButtonPressed() { 
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let byNameAction = UIAlertAction(title: "Sort by name", style: .default) { [weak self] _ in
            self?.isFilteredByName = true
            self?.updateBooksByName()
        }
        alertController.addAction(byNameAction)
        
        let byDateAction = UIAlertAction(title: "Sort by date", style: .default) { [weak self] _ in
            self?.isFilteredByName = false
            self?.updateBooksByDate()
        }
        alertController.addAction(byDateAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        tableView.reloadData()
    }
    
    private func updateBooksByName() {
        var updatedBooks = bookStore.books
        updatedBooks.sort { $0.name < $1.name}
        bookStore.books = updatedBooks
        tableView.reloadData()
    }
    
    private func updateBooksByDate() {
        var updatedBooks = bookStore.books
        updatedBooks.sort { stringToDate(date: $0.date) < stringToDate(date: $1.date) }
        bookStore.books = updatedBooks
        tableView.reloadData()
    }
    
    private func stringToDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let newDate = dateFormatter.date(from: date) ?? Date()
        return newDate
    }
    
    private func isTableEmpty() {
        if bookStore.books.isEmpty {
            emptyTextLabel.isHidden = false
            filterButton.isHidden = true
        } else {
            emptyTextLabel.isHidden = true
            filterButton.isHidden = false
        }
    }
    
    //MARK: - Configuration
    private func prepareViews() {
        title = "Books list"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.largeTitleDisplayMode = .always
        
        navigationItem.hidesBackButton = true
        
        emptyTextLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        
        emptyTextLabel.text = "Empty list"
        emptyTextLabel.font = .boldSystemFont(ofSize: 24)
        emptyTextLabel.textColor = .lightGray
        emptyTextLabel.isHidden = true
        
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.tintColor = .systemBlue
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        
        filterButton.setImage(UIImage(systemName: "arrow.up.and.down.text.horizontal"), for: .normal)
        filterButton.tintColor = .systemBlue
        filterButton.addTarget(self, action: #selector(filterButtonPressed), for: .touchUpInside)
    }
    
    private func addSubviews() {
        tableView.addSubview(emptyTextLabel)
        view.addSubview(tableView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: filterButton)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            emptyTextLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            emptyTextLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor, constant: -140),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

//MARK: - Extensions
extension BooksVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookStore.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reusedCell)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: reusedCell)
        
        guard let cell = cell else {
            return UITableViewCell(style: .default, reuseIdentifier: reusedCell)
        }
        
        cell.textLabel?.text = bookStore.books[indexPath.row].name
        cell.detailTextLabel?.text = bookStore.books[indexPath.row].date
        cell.detailTextLabel?.textColor = .gray
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

extension BooksVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedBookNumber = indexPath.row
        tableView.deselectRow(at: indexPath, animated:  true)
        let vc = EditingVC()
        vc.booksViewController = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeRead = UIContextualAction(style: .normal, title: "") { [weak self] action, view, success in
            guard let self = self else { return }
            tableView.performBatchUpdates {
                self.bookStore.removeBook(indexPath: indexPath)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.isTableEmpty()
            }
        }
        
        swipeRead.backgroundColor = .red
        swipeRead.title = "Delete"
        
        return UISwipeActionsConfiguration(actions: [swipeRead])
    }
}
