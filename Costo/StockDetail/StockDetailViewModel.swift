//
//  StockDetailViewModel.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/21.
//

import SwiftUI
import Observation

@MainActor
@Observable
final class StockDetailViewModel {
    
    let groceryInfo: GroceryInfo
    let viewType: PreviousViewType
    var showingEditView = false
    var isShowAlert = false
    
    private let grocery: Grocery
    
    init(groceryInfo: GroceryInfo, viewType: PreviousViewType) {
        self.groceryInfo = groceryInfo
        self.grocery = groceryInfo.grocery
        self.viewType = viewType
    }
    
    func moveToTrash() {
        grocery.inTrash = true
        isShowAlert = true
    }
    
    func backToList() {
        grocery.inTrash = false
        isShowAlert = true
    }
}

// MARK: - enum

extension StockDetailViewModel {
    
    enum PreviousViewType {
        case list
        case trash
    }
}
