//
//  PKBitMaskCategory.swift
//  
//
//  Created by Maertens Yann-Christophe on 18/02/23.
//

import Foundation

public struct PKBitMaskCategory: OptionSet {
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    public let rawValue: UInt32

    public static let allClear         = PKBitMaskCategory([])
    public static let allSet           = PKBitMaskCategory(rawValue: 0xFFFFFFFF)
    public static let player           = PKBitMaskCategory(rawValue: 0x1 << 0)
    public static let playerProjectile = PKBitMaskCategory(rawValue: 0x1 << 1)
    public static let enemy            = PKBitMaskCategory(rawValue: 0x1 << 2)
    public static let enemyProjectile  = PKBitMaskCategory(rawValue: 0x1 << 3)
    public static let object           = PKBitMaskCategory(rawValue: 0x1 << 4)
    public static let wall             = PKBitMaskCategory(rawValue: 0x1 << 5)
    public static let ground           = PKBitMaskCategory(rawValue: 0x1 << 6)
}
