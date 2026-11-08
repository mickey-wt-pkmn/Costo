//
//  History.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/24.
//

import SwiftData
import Foundation

@Model
final class History {
    @Attribute(.unique) var historyId: String
    @Relationship(deleteRule: .cascade) var useList: [UseIngredientHistory]
    var allCost: Double
    var createdAt: Date = Date()
    
    init(useList: [UseIngredientHistory]) {
        self.historyId = UUID().uuidString
        self.useList = useList
        self.createdAt = Date()
        
        let allCost = useList.reduce(into: 0) { result, value in
            result += value.cost
        }
        // 小数点 3位で切り捨て
        self.allCost = floor(allCost * 100) / 100
    }
}
