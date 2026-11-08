//
//  EditStockViewModel.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/22.
//

import SwiftUI
import SwiftData
import Observation

@MainActor
@Observable
final class EditStockViewModel {
    
    var inputModel: GroceryInputModel = .init()
    var isShowAlert = false
    
    private(set) var isEnableSave = false
    private(set) var alertType: AlertType?
    let viewType: ViewType
    
    private let grocery: Grocery?
    
    init(grocery: Grocery? = nil, viewType: ViewType) {
        self.grocery = grocery
        self.viewType = viewType
        if let grocery = grocery {
            self.inputModel = GroceryInputModel.convertToEditInput(grocery)
        }
    }
    
    func save(_ modelContext: ModelContext) {
        switch viewType {
        case .add:
            addItem(modelContext)
        case .edit:
            editItem(modelContext)
        }
    }
    
    func reset() {
        inputModel.reset()
        isEnableSave = false
    }
    
    func checkValue(_ type: CheckValueType) {
        // 小数点第1位までしか入力できないように制限
        switch type {
        case .price(let old, let new):
            if new.floatingPointCount > 1 {
                inputModel.price = old
            }
        case .amount(let old, let new):
            if new.floatingPointCount > 1 {
                inputModel.amount = old
            }
        case .remainingAmount(let old, let new):
            if new.floatingPointCount > 1 {
                inputModel.remainingAmount = old
            }
        case .pass:
            break
        }
        // enable チェック
        switch viewType {
        case .add:
            checkEnableAddSave()
        case .edit:
            checkEnableEditSave()
        }
    }
    
    private func checkEnableAddSave() {
        let isValidName = !inputModel.name.isEmpty
        let isValidPrice = (inputModel.price ?? 0) > 0
        let isValidAmount = (inputModel.amount ?? 0) > 0
        
        isEnableSave = isValidName && isValidPrice && isValidAmount
    }
    
    private func checkEnableEditSave() {
        let isValidName = !inputModel.name.isEmpty
        let isValidPrice = (inputModel.price ?? 0) > 0
        let isValidAmount = (inputModel.amount ?? 0) > 0
        let isValidRemainingAmount = inputModel.remainingAmount != nil
        
        isEnableSave = isValidName && isValidPrice && isValidAmount && isValidRemainingAmount
    }
    
    private func editItem(_ modelContext: ModelContext) {
        guard let grocery = grocery else {
            return
        }
        let price = inputModel.price ?? 0
        let amount = inputModel.amount ?? 0
        let remainingAmount = inputModel.remainingAmount ?? 0
        let calcRemainingAmount = (remainingAmount > amount) ? amount : remainingAmount
        
        grocery.name = inputModel.name
        grocery.price = price
        grocery.amount = amount
        grocery.remainingAmount = calcRemainingAmount
        grocery.unit = inputModel.unit
        
        do {
            try modelContext.save()
            isShowAlert = true
            alertType = .editSuccess
        } catch {
            isShowAlert = true
            alertType = .error(error)
        }
    }
    
    private func addItem(_ modelContext: ModelContext) {
        let price = inputModel.price ?? 0
        let amount = inputModel.amount ?? 0
        
        let newItem = Grocery(
            name: inputModel.name,
            price: price,
            amount: amount,
            unit: inputModel.unit,
            remainingAmount: amount,
            inTrash: false)
        
        modelContext.insert(newItem)
        do {
            try modelContext.save()
            isShowAlert = true
            alertType = .addSuccess
        } catch {
            isShowAlert = true
            alertType = .error(error)
        }
    }
}

// MARK: - enum

extension EditStockViewModel {
    
    enum ViewType {
        case add
        case edit
        
        var title: String {
            switch self {
            case .add:
                return "Add Stock"
            case .edit:
                return "Edit Stock"
            }
        }
    }
    
    enum CheckValueType {
        case price(old: Double?, new: Double?)
        case amount(old: Double?, new: Double?)
        case remainingAmount(old: Double?, new: Double?)
        case pass
    }
    
    enum AlertType {
        case error(any Error)
        case addSuccess
        case editSuccess
    }
}
