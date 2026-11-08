//
//  IngredientInfo.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/24.
//

import Foundation
import SwiftData

struct IngredientInfo {
    let modelList: [IngredientModel]
    var allCost: String? {
        let value = modelList.reduce(into: 0) { (result, value)  in
            result = result + value.valueModel.cost
        }
        guard value > 0 else {
            return nil
        }
        return "$ \(value.formatted())"
    }
}

extension IngredientInfo {
    
    struct IngredientModel: Identifiable {
        let id = UUID()
        let grocery: Grocery
        
        var useAmount: Double
        var displayModel: IngredientDisplayModel {
            return .convertToModel(grocery, useAmountValue: useAmount)
        }
        var valueModel: IngredientValueModel {
            return .convertToModel(grocery, useAmount: useAmount)
        }
        
        static func convertToModel(_ grocery: Grocery, useAmount: Double) -> Self {
            return .init(
                grocery: grocery,
                useAmount: useAmount)
        }
    }
    
    struct IngredientValueModel {
        let cost: Double
        let availableAmount: Double
        let unit: UnitType
        
        static func convertToModel(_ grocery: Grocery, useAmount: Double) -> Self {
            // 小数点 3位で切り捨て
            let availableAmount = floor((grocery.remainingAmount - useAmount) * 100) / 100
            let costForPerWeight = grocery.price / grocery.amount
            let cost = costForPerWeight * useAmount
            let floorCost = floor(cost * 100) / 100
            
            return .init(
                cost: floorCost,
                availableAmount: availableAmount, 
                unit: grocery.unit)
        }
    }
    
    struct IngredientDisplayModel {
        let name: String
        let useAmount: String
        let availableAmount: String
        let cost: String
        
        static func convertToModel(_ grocery: Grocery, useAmountValue: Double) -> Self {
            // 小数点 3位で切り捨て
            let availableAmount = floor((grocery.remainingAmount - useAmountValue) * 100) / 100
            let costForPerWeight = grocery.price / grocery.amount
            let cost = costForPerWeight * useAmountValue
            let floorCost = floor(cost * 100) / 100
            
            return .init(
                name: grocery.name,
                useAmount: "\(useAmountValue.formatted()) \(grocery.unit.string)",
                availableAmount: "\(availableAmount.formatted()) \(grocery.unit.string)",
                cost: "$ \(floorCost.formatted())")
        }
    }
}
