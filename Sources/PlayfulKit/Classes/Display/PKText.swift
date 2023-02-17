//
//  PKText.swift
//  PlayfulKit
//
//  Created by Maertens Yann-Christophe on 11/08/22.
//

import SpriteKit

public class PKText: PKTextProtocol {
    
    public struct Paramater {
        public init(content: String,
                    fontName: String? = UIFont.randomSystemFontName,
                    fontSize: CGFloat = 16,
                    fontColor: UIColor = .white,
                    strokeWidth: CGFloat = 0,
                    strokeColor: UIColor = .clear,
                    lineSpacing: CGFloat = 5,
                    padding: CGFloat = 0) {
            self.content = content
            self.fontName = fontName
            self.fontSize = fontSize
            self.fontColor = fontColor
            self.strokeWidth = strokeWidth
            self.strokeColor = strokeColor
            self.lineSpacing = lineSpacing
            self.padding = padding
        }
        var content: String
        var fontName: String?
        var fontSize: CGFloat
        var fontColor: UIColor
        var strokeWidth: CGFloat
        var strokeColor: UIColor
        var lineSpacing: CGFloat
        var padding: CGFloat
    }
    
    public func attributedText(parameter: Paramater) -> NSAttributedString? {
        guard let fontName = parameter.fontName else {
            return nil
        }
        guard let font: UIFont = UIFont(name: fontName,
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
