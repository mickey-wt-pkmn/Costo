//
//  TabType.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/21.
//

import SwiftUI

enum TabType {
    case stockList
    case cooking
    case trashList
    case history
}

extension TabType {
    
    var title: String {
        switch self {
        case .stockList:
            return "Stock List"
        case .cooking:
            return "Cooking"
        case .trashList:
            return "Trash List"
        case .history:
            return "History"
        }
    }
    
    var imageName: String {
        switch self {
        case .stockList:
            return "shippingbox.and.arrow.backward"
        case .cooking:
            return "fork.knife"
        case .trashList:
            return "trash"
        case .history:
            return "list.bullet"
        }
    }
}
