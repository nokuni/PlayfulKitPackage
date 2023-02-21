//
//  UIImageGradient.swift
//  PlayfulKit
//
//  Created by Yann Christophe MAERTENS on 08/02/2023.
//

import UIKit

public extension UIImage {
    /// Gradient from UIImage.
    struct Gradient {
        /// Points of the UIImage Gradient
        public enum Points {
            case topLeftToBottomRight
            case bottomRightToTopLeft
            case bottomLeftToTopRight
            case topRightToBottomLeft
            case bottomToTop
            case topToBottom
            
            var positions: (start: CGPoint, end: CGPoint) {
                switch self {
                case .topLeftToBottomRight:
                    return (start: CGPoint(x: 0, y: 0), end: CGPoint(x: 1, y: 1))
                case .bottomRightToTopLeft:
                    return (start: CGPoint(x: 1, y: 1), end: CGPoint(x: 0, y: 0))
                case .bottomLeftToTopRight:
                    return (start: CGPoint(x: 0, y: 1), end: CGPoint(x: 1, y: 0))
                case .topRightToBottomLeft:
                    return (start: CGPoint(x: 1, y: 0), end: CGPoint(x: 0, y: 1))
                case .bottomToTop:
                    return (start: CGPoint(x: 0.5, y: 1), end: CGPoint(x: 0.5, y: 1))
                case .topToBottom:
                    return (start: CGPoint(x: 0.5, y: 0), end: CGPoint(x: 0.5, y: 1))
                }
            }
        }
        /// Returns a UIImage defined by its dimension,  points and colors.
        static func image(withBounds: CGRect, points: Points, colors: [CGColor]) -> UIImage {
            
            // Configure the gradient layer based on input
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = withBounds
            gradientLayer.colors = colors
            gradientLayer.startPoint = points.positions.start
            gradientLayer.endPoint = points.positions.end
            // Render the image using the gradient layer
            UIGraphicsBeginImageContext(gradientLayer.bounds.size)
            gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return image!
        }
    }
}
