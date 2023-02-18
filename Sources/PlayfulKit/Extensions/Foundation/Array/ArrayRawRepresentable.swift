//
//  ArrayRawRepresentable.swift
//  
//
//  Created by Maertens Yann-Christophe on 18/02/23.
//

import Foundation

extension Array where Element: RawRepresentable {
    func withXOROperators() -> UInt32? {
        guard !self.isEmpty else { return nil }
        let stringArray = self.compactMap { "\($0.rawValue)" }
        let string = stringArray.joined(separator: " | ")
        let dictionary = self.intoDictionary()
        return string.intoUInt32(from: dictionary)
    }
    
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
