//
//  Optional<Double>+FloatingPoint.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/28.
//

import Foundation

extension Optional<Double> {
    
    var floatingPointCount: Int {
        guard let float = self, floor(float) != float else {
            return 0
        }
        guard let floatNumber = float.description.components(separatedBy: ".").last else {
            return 0
        }
        return floatNumber.count
    }
}
