//
//  GroceryInfo.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/23.
//

import Foundation

struct GroceryInfo: Identifiable {
    let id = UUID()
    var displayModel: GroceryDisplayModel {
        GroceryDisplayModel.convertToModel(grocery)
    }
    let grocery: Grocery
}

extension GroceryInfo {
    
    struct GroceryDisplayModel {
        let name: String
        let price: String
        let amount: String
        let remainingAmount: String
        
        static func convertToModel(_ grocery: Grocery) -> Self {
            return .init(
                name: grocery.name,
                price: "$ \(grocery.price.formatted())",
                amount: "\(grocery.amount.formatted()) \(grocery.unit.string)",
                remainingAmount: "\(grocery.remainingAmount.formatted()) \(grocery.unit.string)")
        }
    }
}
