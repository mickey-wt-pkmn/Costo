//
//  CookingViewModel.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/24.
//

import SwiftUI
import SwiftData
import Observation

@MainActor
@Observable
final class CookingViewModel {
    
    var isShowAlert = false
    var isShowConfirmationDialog = false
    var ingredientModel: IngredientInfo.IngredientModel?
    var useIngredientList: [UseIngredientModel] = []
    
    private(set) var alertType: AlertType?
    private(set) var isEnableCooking = false
    
    func checkEnableCooking() {
        isEnableCooking = !useIngredientList.isEmpty
    }
    
    func useItem(_ ingredientInfo: IngredientInfo, modelContext: ModelContext) {
        let useList = ingredientInfo.modelList.map {
            UseIngredientHistory(
                name: $0.displayModel.name,
                useAmount: $0.useAmount,
                unit: $0.valueModel.unit,
                cost: $0.valueModel.cost)
        }
        let history = History(useList: useList)
        modelContext.insert(history)
        
        ingredientInfo.modelList.forEach {
            // 小数点 3位で切り捨て
            $0.grocery.remainingAmount = floor(($0.grocery.remainingAmount - $0.useAmount) * 100) / 100
        }
        do {
            try modelContext.save()
            isShowAlert = true
            alertType = .useSuccess
        } catch {
            isShowAlert = true
            alertType = .error(error)
        }
        useIngredientList = []
        isEnableCooking = false
    }
}

// MARK: - enum

extension CookingViewModel {
    
    enum AlertType {
        case error(any Error)
        case useSuccess
    }
}
