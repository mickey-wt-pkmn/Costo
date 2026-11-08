//
//  HistoryDetailInfo.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/24.
//

import Foundation

struct HistoryDetailInfo {
    let displayModel: HistoryDetailDisplayModel
}

extension HistoryDetailInfo {
    
    struct IngredientHistoryDisplayModel: Identifiable {
        let id = UUID()
        let name: String
        let useAmount: String
        let cost: String
        
        static func convertToModel(_ ingredientHistory: UseIngredientHistory) -> Self {
            return .init(
                name: ingredientHistory.name,
                useAmount: "\(ingredientHistory.useAmount.formatted()) \(ingredientHistory.unit.string)",
                cost: "$ \(ingredientHistory.cost.formatted())")
        }
    }
    
    struct HistoryDetailDisplayModel {
        let ingredientHistory: [IngredientHistoryDisplayModel]
        let allCost: String
        
        static func convertToModel(_ history: History) -> Self {
            let ingredientHistory = history.useList.map { IngredientHistoryDisplayModel.convertToModel($0) }
            return .init(
                ingredientHistory: ingredientHistory,
                allCost: "$ \(history.allCost.formatted())")
        }
    }
}
