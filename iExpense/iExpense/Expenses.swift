//
//  Expenses.swift
//  iExpense
//
//  Created by Niklas Fischer on 21/8/22.
//

import Foundation

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    //    custom initializer for our expenses class
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        // if there is no data in the AppStorage or it can't be decoded, initialize an empty array
        items = []
    }
}
