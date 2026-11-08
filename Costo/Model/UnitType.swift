//
//  UnitType.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/20.
//

import Foundation

enum UnitType: Codable, CaseIterable {
    case pound
    case gram
    case millilitre
}

extension UnitType {
    static let PoundGram: Double = 453.6
    static let forPound: [UnitType] = [.gram, .pound]
    
    var string: String {
        switch self {
        case .pound:
            return "lb"
        case .gram:
            return "g"
        case .millilitre:
            return "ml"
        }
    }
}
