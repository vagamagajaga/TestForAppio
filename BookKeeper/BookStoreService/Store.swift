//
//  Store.swift
//  BookKeeper
//
//  Created by Vagan Galstian on 12.04.2023.
//

import Foundation

final class Store {
    
    //MARK: - Properties
    private let defaults = UserDefaults.standard
    private let booksKey = "SavedBooks"
    
    var books: [Book] {
        get {
            guard let data = defaults.data(forKey: booksKey),
                  let books = try? JSONDecoder().decode([Book].self, from: data) else {
                return []
            }
            return books
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно установить новые данные")
                return
            }
            defaults.setValue(data, forKey: booksKey)
        }
    }
    
    //MARK: - Methods
    func removeBook(indexPath: IndexPath) {
        books.remove(at: indexPath.row)
    }
    
    func addBook(book: Book) {
        books.append(book)
    }
}
