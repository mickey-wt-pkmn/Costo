//
//  CostoTests.swift
//  CostoTests
//  
//  Created by mickey-wp on 2026/11/09
//  
//

import XCTest
@testable import Costo

@MainActor
final class CostoTests: XCTestCase {
    
    /// 使用量に応じた原価計算と残量計算(小数第2位切り捨て)
    func testIngredientCostAndAvailableAmountCalculation() {
        let grocery = Grocery(
            name: "Chicken",
            price: 10,
            amount: 300,
            unit: .gram,
            remainingAmount: 300,
            inTrash: false
        )
        // 300g で $10 の食材を 100g 使用 → 原価 $3.33、残量 200g
        let valueModel = IngredientInfo.IngredientValueModel.convertToModel(grocery, useAmount: 100)
        
        XCTAssertEqual(valueModel.cost, 3.33)
        XCTAssertEqual(valueModel.availableAmount, 200)
    }
    
    /// ポンド(lb)登録の食材をグラム(g)で使用するときの換算チェック
    func testPoundToGramConversionInEditIngredientViewModel() {
        // 1 lb(= 453.6g)の在庫
        let grocery = Grocery(
            name: "Carrot",
            price: 5,
            amount: 1,
            unit: .pound,
            remainingAmount: 1,
            inTrash: false
        )
        let ingredientModel = IngredientInfo.IngredientModel.convertToModel(grocery, useAmount: 0)
        let viewModel = EditIngredientViewModel(ingredientModel: ingredientModel, viewType: .add)
        
        // 単位を gram に切り替え、400g 使用(453.6g 以下なので選択可能)
        viewModel.useUnit = .gram
        viewModel.useAmount = 400
        viewModel.checkValue(.pass)
        XCTAssertTrue(viewModel.isEnableSelect)
        XCTAssertFalse(viewModel.isExceedAmount)
        
        // 500g 使用(453.6g を超えるので上限エラー)
        viewModel.useAmount = 500
        viewModel.checkValue(.pass)
        XCTAssertFalse(viewModel.isEnableSelect)
        XCTAssertTrue(viewModel.isExceedAmount)
    }
    
    /// 小数第1位までの入力制限と Save ボタンの有効判定
    func testEditStockValidationAndDecimalLimit() {
        let viewModel = EditStockViewModel(viewType: .add)
        viewModel.inputModel.name = "Milk"
        viewModel.inputModel.price = 2.5
        viewModel.inputModel.amount = 1000
        viewModel.checkValue(.pass)
        XCTAssertTrue(viewModel.isEnableSave)
        
        // 小数第2位(2.55)が入力されたら直前の値(2.5)に戻す
        viewModel.inputModel.price = 2.55
        viewModel.checkValue(.price(old: 2.5, new: 2.55))
        XCTAssertEqual(viewModel.inputModel.price, 2.5)
    }
}
