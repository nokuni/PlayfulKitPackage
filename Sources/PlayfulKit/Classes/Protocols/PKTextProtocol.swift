//
//  PKTextProtocol.swift
//  
//
//  Created by Maertens Yann-Christophe on 17/02/23.
//

import Foundation

public protocol PKTextProtocol {
    func attributedText(parameter: PKText.Paramater) -> NSAttributedString?
}
