//
//  UseIngredientHistory.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/24.
//

import SwiftData

@Model
final class UseIngredientHistory {
    var name: String
    var useAmount: Double
    var unit: UnitType
    var cost: Double
    
    init(name: String, useAmount: Double, unit: UnitType, cost: Double) {
        self.name = name
        self.useAmount = useAmount
        self.unit = unit
        self.cost = cost
    }
}
