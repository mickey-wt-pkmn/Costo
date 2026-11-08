//
//  PreviewSampleData.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/21.
//

import SwiftData
import Foundation

@MainActor
enum PreviewSampleData {
    
    #if DEBUG
    static var groceryContainer: ModelContainer = {
        let schema = Schema([Grocery.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        let carrot = Grocery(name: "carrot", price: 20, amount: 200, unit: .gram, remainingAmount: 200, inTrash: false)
        let watermelon = Grocery(name: "watermelon", price: 20, amount: 100, unit: .gram, remainingAmount: 100, inTrash: false)
        let cucumber = Grocery(name: "cucumber", price: 20, amount: 100, unit: .gram, remainingAmount: 0, inTrash: false)
        let cabbeage = Grocery(name: "cabbeage", price: 10, amount: 100, unit: .gram, remainingAmount: 100, inTrash: true)
        container.mainContext.insert(carrot)
        container.mainContext.insert(watermelon)
        container.mainContext.insert(cucumber)
        container.mainContext.insert(cabbeage)
        return container
    }()
    
    static var historyContainer: ModelContainer = {
        let schema = Schema([History.self, UseIngredientHistory.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        let carrot = UseIngredientHistory(name: "carrot", useAmount: 20, unit: .gram, cost: 100)
        let watermelon = UseIngredientHistory(name: "watermelon", useAmount: 10, unit: .gram, cost: 200)
        let cucumber = UseIngredientHistory(name: "cucumber", useAmount: 30, unit: .gram, cost: 300)
        
        let history = History(useList: [carrot, watermelon, cucumber])
        container.mainContext.insert(history)
        return container
    }()
    
    static var carrot: Grocery {
        Grocery(name: "carrot", price: 20, amount: 100, unit: .pound, remainingAmount: 100, inTrash: false)
    }
    
    static var history: History {
        let carrot = UseIngredientHistory(name: "carrot", useAmount: 20, unit: .gram, cost: 100)
        let watermelon = UseIngredientHistory(name: "watermelon", useAmount: 10, unit: .gram, cost: 200)
        let cucumber = UseIngredientHistory(name: "cucumber", useAmount: 30, unit: .gram, cost: 300)
        return History(useList: [carrot, watermelon, cucumber])
    }
    
    static var list: [Grocery] {
        let carrot = Grocery(name: "carrot", price: 20, amount: 200, unit: .gram, remainingAmount: 200, inTrash: false)
        let watermelon = Grocery(name: "watermelon", price: 20, amount: 100, unit: .gram, remainingAmount: 100, inTrash: false)
        let cucumber = Grocery(name: "cucumber", price: 20, amount: 100, unit: .gram, remainingAmount: 0, inTrash: false)
        let cabbeage = Grocery(name: "cabbeage", price: 10, amount: 100, unit: .gram, remainingAmount: 100, inTrash: true)
        return [carrot, watermelon, cucumber, cabbeage]
    }
    
    #endif
}
