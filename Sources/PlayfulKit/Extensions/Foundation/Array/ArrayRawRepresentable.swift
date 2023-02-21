//
//  ArrayRawRepresentable.swift
//  
//
//  Created by Maertens Yann-Christophe on 18/02/23.
//

import Foundation

public extension Array where Element: RawRepresentable {

    /// Returns a UInt32 value from enum values.
    func withXOROperators() -> UInt32? {
        guard !self.isEmpty else { return nil }
        let stringArray = self.compactMap { "\($0.rawValue)" }
        let string = stringArray.joined(separator: " | ")
        let dictionary = self.intoDictionary()
        return string.intoUInt32(from: dictionary)
    }

    /// Returns a dictionary containing UInt32 values from enum values.
    func intoDictionary() -> [Int: UInt32] {
        var dictionary: [Int: UInt32] = [:]
        for (index, element) in self.enumerated() {
            if let number = element.rawValue as? UInt32 {
                dictionary[index] = number
            }
        }
        return dictionary
    }
}
