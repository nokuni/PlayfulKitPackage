//
//  TextManager.swift
//  PlayfulKit
//
//  Created by Maertens Yann-Christophe on 11/08/22.
//

import SpriteKit
import Utility_Toolbox

final public class TextManager {
    
    public struct Paramater {
        public init(content: String,
                    fontName: String? = UIFont.firstSystemFontName,
                    fontSize: CGFloat = 16,
                    fontColor: UIColor = .white,
                    strokeWidth: CGFloat = 0,
                    strokeColor: UIColor = .clear,
                    hasAlignment: Bool = true,
                    lineSpacing: CGFloat = 5,
                    padding: CGFloat = 0) {
            self.content = content
            self.fontName = fontName
            self.fontSize = fontSize
            self.fontColor = fontColor
            self.strokeWidth = strokeWidth
            self.strokeColor = strokeColor
            self.hasAlignment = hasAlignment
            self.lineSpacing = lineSpacing
            self.padding = padding
        }
        public var content: String
        public var fontName: String?
        public var fontSize: CGFloat
        public var fontColor: UIColor
        public var strokeWidth: CGFloat
        public var strokeColor: UIColor
        public var hasAlignment: Bool
        public var lineSpacing: CGFloat
        public var padding: CGFloat
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
        
        guard !parameter.content.isEmpty else { return nil }
        
        let attributedText = NSMutableAttributedString(string: parameter.content, attributes: attributes)
        
        if parameter.content.contains("@") {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemName: "star.fill")
            let imageString = NSAttributedString(attachment: imageAttachment)
            attributedText.append(imageString)
        }
        
        return attributedText
    }
}
