//
//  GroceryInputModel.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/22.
//

import Foundation

struct GroceryInputModel {
    var name: String = ""
    var price: Double?
    var amount: Double?
    var remainingAmount: Double?
    var unit: UnitType = .gram
    
    mutating func reset() {
        self.name = ""
        self.price = nil
        self.amount = nil
        self.remainingAmount = nil
        self.unit = .gram
    }
    
    static func convertToEditInput(_ grocery: Grocery) -> Self {
        return .init(name: grocery.name, price: grocery.price, amount: grocery.remainingAmount, remainingAmount: grocery.remainingAmount, unit: grocery.unit)
    }
}
