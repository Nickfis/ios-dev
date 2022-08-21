//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Niklas Fischer on 21/8/22.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
