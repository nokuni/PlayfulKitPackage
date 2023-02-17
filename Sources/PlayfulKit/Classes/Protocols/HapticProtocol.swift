//
//  HapticProtocol.swift
//  
//
//  Created by Maertens Yann-Christophe on 17/02/23.
//

import Foundation

public protocol HapticProtocol {
    func prepareHaptics()
    func simpleSuccess()
    func complexSuccess(intensity: Float, sharpness: Float)
}
