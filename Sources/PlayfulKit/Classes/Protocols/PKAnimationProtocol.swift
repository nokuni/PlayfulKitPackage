//
//  PKAnimationProtocol.swift
//  
//
//  Created by Maertens Yann-Christophe on 17/02/23.
//

import SpriteKit

public protocol PKAnimationProtocol {
    func start(actionBeforeAnimation: (() -> Void)?,
               with animation: SKAction,
               on node: SKNode,
               and actionAfterAnimation: (() -> Void)?)
}
