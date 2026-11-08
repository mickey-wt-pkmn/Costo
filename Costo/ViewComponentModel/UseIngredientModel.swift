//
//  UseIngredientModel.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/25.
//

import SwiftData

@Observable
final class UseIngredientModel {
    let modelId: PersistentIdentifier
    var useAmount: Double
    
    init(modelId: PersistentIdentifier, useAmount: Double) {
        self.modelId = modelId
        self.useAmount = useAmount
    }
}
