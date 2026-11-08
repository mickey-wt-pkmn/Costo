//
//  Grocery.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/20.
//

import Foundation
import SwiftData

@Model
final class Grocery {
    /// 商品名
    var name: String
    /// 金額
    var price: Double
    /// 数
    var amount: Double
    /// 単位
    var unit: UnitType
    /// 残り数
    var remainingAmount: Double
    /// ゴミ箱にあるか
    var inTrash: Bool
    /// 登録日
    var registDate: Date
    
    init(name: String, price: Double, amount: Double, unit: UnitType, remainingAmount: Double, inTrash: Bool) {
        self.name = name
        self.price = price
        self.amount = amount
        self.unit = unit
        self.remainingAmount = remainingAmount
        self.inTrash = inTrash
        self.registDate = Date()
    }
}
