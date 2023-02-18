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
    case player           = 0x00000002
    case playerProjectile = 0x00000004
    case enemy            = 0x00000006
    case enemyProjectile  = 0x00000008
    case object           = 0x00000010
    case wall             = 0x00000012
    case ground           = 0x00000014
}
