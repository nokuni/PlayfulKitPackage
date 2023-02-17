//
//  PKText.swift
//  PlayfulKit
//
//  Created by Maertens Yann-Christophe on 11/08/22.
//

import SpriteKit

public class PKText: PKTextProtocol {
    
    public struct Paramater {
        var content: String
        var font: String
        var fontSize: CGFloat = 16
        var fontColor: UIColor = .white
        var strokeWidth: CGFloat = 0
        var strokeColor: UIColor = .clear
        var lineSpacing: CGFloat = 5
        var padding: CGFloat = 0
    }
    
    public func attributedText(parameter: Paramater) -> NSAttributedString? {
        guard let font: UIFont = UIFont(name: parameter.font,
                                        size: parameter.fontSize) else {
            return nil
        }
        let color: UIColor = parameter.fontColor
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = parameter.lineSpacing
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .strokeWidth: parameter.strokeWidth,
            .strokeColor: parameter.strokeColor,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedText = NSAttributedString(string: parameter.content,
                                                attributes: attributes)
        return attributedText
    }
}
