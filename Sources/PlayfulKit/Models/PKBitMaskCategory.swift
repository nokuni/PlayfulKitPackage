//
//  PKBitMaskCategory.swift
//  
//
//  Created by Maertens Yann-Christophe on 18/02/23.
//

import Foundation

public enum PKBitMaskCategory: UInt32 {
    case allClear         = 0x00000000
    case allSet           = 0xFFFFFFFF
    case player           = 2
    case playerProjectile = 4
    case enemy            = 6
    case enemyProjectile  = 8
    case object           = 10
    case wall             = 12
    case ground           = 14
}
