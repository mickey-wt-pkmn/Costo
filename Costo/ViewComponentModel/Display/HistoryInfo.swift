//
//  HistoryInfo.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/24.
//

import Foundation

struct HistoryInfo: Identifiable {
    let id = UUID()
    var displayModel: HistoryDisplayModel {
        HistoryDisplayModel.convertToModel(history)
    }
    let history: History
}

extension HistoryInfo {
    
    struct HistoryDisplayModel {
        let historyId: String
        let allCost: String
        let history: History
        
        static func convertToModel(_ history: History) -> Self {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            return .init(
                historyId: formatter.string(from: history.createdAt),
                allCost: "$ \(history.allCost.formatted())",
                history: history)
        }
    }
}
