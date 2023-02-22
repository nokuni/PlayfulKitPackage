//
//  IntExtension.swift
//  
//
//  Created by Yann Christophe MAERTENS on 20/02/2023.
//

import Foundation

public extension Int {
    /// Returns a string of the number with an amount of leading zeros.
    func leadingZeros(amount: Int) -> String {
        let result = String(format: "%0\(amount)d", self)
        return result
    }
}
