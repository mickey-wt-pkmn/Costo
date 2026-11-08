//
//  EditIngredientViewModel.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/24.
//

import SwiftUI
import Observation

@MainActor
@Observable
final class EditIngredientViewModel {
    
    var useAmount: Double?
    var useUnit: UnitType
    
    private(set) var isExceedAmount = false
    private(set) var isEnableSelect = false
    let ingredientModel: IngredientInfo.IngredientModel
    let viewType: ViewType
    
    init(ingredientModel: IngredientInfo.IngredientModel, viewType: ViewType) {
        self.ingredientModel = ingredientModel
        self.viewType = viewType
        self.useAmount = ingredientModel.useAmount > 0 ? ingredientModel.useAmount : nil
        self.useUnit = ingredientModel.valueModel.unit
    }
    
    func checkValue(_ type: CheckValueType) {
        // 小数点第1位までしか入力できないように制限
        switch type {
        case .useAmount(let old, let new):
            if new.floatingPointCount > 1 {
                useAmount = old
            }
        case .pass:
            break
        }
        checkEnableState()
    }
    
    private func checkEnableState() {
        if let value = useAmount, value > 0 {
            let availableAmount = ingredientModel.valueModel.availableAmount
            
            let isAvailable: Bool
            // 登録時は pound で使用時に gram を選択した場合
            if ingredientModel.valueModel.unit == .pound && useUnit == .gram {
                let convertAvalableAmount = UnitType.PoundGram * availableAmount
                isAvailable = (value <= convertAvalableAmount)
            } else {
                isAvailable = (value <= availableAmount)
            }
            isExceedAmount = !isAvailable
            isEnableSelect = isAvailable
        } else {
            isExceedAmount = false
            isEnableSelect = false
        }
    }
}

// MARK: - enum

extension EditIngredientViewModel {
    
    enum ViewType {
        case add
        case edit
        
        var title: String {
            switch self {
            case .add:
                return "Add Ingredient"
            case .edit:
                return "Edit Ingredient"
            }
        }
    }
    
    enum CheckValueType {
        case useAmount(old: Double?, new: Double?)
        case pass
    }
}
