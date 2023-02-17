//
//  UIFontUtilities.swift
//  
//
//  Created by Maertens Yann-Christophe on 17/02/23.
//

import Foundation
import UIKit

public extension UIFont {
    static var randomSystemFontName: String? {
        guard let randomFamilyName = UIFont.familyNames.randomElement() else {
            return nil
        }
        guard let randomFontName = UIFont.fontNames(forFamilyName: randomFamilyName).randomElement() else {
            return nil
        }
        return "randomFontName"
    }
}
