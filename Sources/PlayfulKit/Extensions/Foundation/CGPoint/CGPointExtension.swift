//
//  CGPointExtension.swift
//  PlayfulKit
//
//  Created by Yann Christophe MAERTENS on 07/02/2023.
//

import UIKit

public extension CGPoint {

    /// The center position of the current device.
    static var center: CGPoint {
        return CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
    }
    
    static func + (point: CGPoint, value: CGFloat) -> CGPoint {
        return CGPoint(x: point.x + value, y: point.y + value)
    }
    
    static func - (point: CGPoint, value: CGFloat) -> CGPoint {
        return CGPoint(x: point.x - value, y: point.y - value)
    }
    
    static func * (point: CGPoint, value: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * value, y: point.y * value)
    }
    
    static func / (point: CGPoint, value: CGFloat) -> CGPoint {
        return CGPoint(x: point.x / value, y: point.y / value)
    }
}
