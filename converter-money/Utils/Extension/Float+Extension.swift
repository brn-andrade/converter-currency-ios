//
//  Float+Extension.swift
//  converter-money
//
//  Created by Brunno Andrade on 05/10/20.
//

import Foundation

extension Float {
    
    func formatCurrency() -> String {
        return String(format: "%.02f", self)
    }
}
