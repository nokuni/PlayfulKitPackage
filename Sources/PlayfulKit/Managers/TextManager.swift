//
//  TextManager.swift
//  PlayfulKit
//
//  Created by Maertens Yann-Christophe on 11/08/22.
//

import SpriteKit
import SwiftUI
import Utility_Toolbox

final public class TextManager {
    
    public init() { }
    
    public struct Paramater {
        public init(content: String,
                    fontName: String? = UIFont.firstSystemFontName,
                    fontSize: CGFloat = 16,
                    fontColor: UIColor = .white,
                    strokeWidth: CGFloat = 0,
                    strokeColor: UIColor = .clear,
                    horizontalAlignmentMode: SKLabelHorizontalAlignmentMode = .left,
                    verticalAlignmentMode: SKLabelVerticalAlignmentMode = .top,
                    lineSpacing: CGFloat = 5,
                    padding: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)) {
            self.content = content
            self.fontName = fontName
            self.fontSize = fontSize
            self.fontColor = fontColor
            self.strokeWidth = strokeWidth
            self.strokeColor = strokeColor
            self.horizontalAlignmentMode = horizontalAlignmentMode
            self.verticalAlignmentMode = verticalAlignmentMode
            self.lineSpacing = lineSpacing
            self.padding = padding
        }
        public var content: String
        public var fontName: String?
        public var fontSize: CGFloat
        public var fontColor: UIColor
        public var strokeWidth: CGFloat
        public var strokeColor: UIColor
        public var horizontalAlignmentMode: SKLabelHorizontalAlignmentMode
        public var verticalAlignmentMode: SKLabelVerticalAlignmentMode
        public var lineSpacing: CGFloat
        public var padding: EdgeInsets
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
        
        let attributedText = NSMutableAttributedString(string: parameter.content, attributes: attributes)
        
        return attributedText
    }
}
