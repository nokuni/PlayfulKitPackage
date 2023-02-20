//
//  PKGroupProtocol.swift
//  
//
//  Created by Maertens Yann-Christophe on 17/02/23.
//

import SpriteKit

public protocol PKGroupProtocol {
    func createSpriteList(of nodes: [SKNode],
                          at startingPosition: CGPoint,
                          in node: SKNode,
                          axes: Axes,
                          alignment: Adjustement,
                          spacing: CGFloat)
    
    func createSpriteCollectionWithDelay(of nodes: [SKSpriteNode],
                                         at startingPosition: CGPoint,
                                         in node: SKNode,
                                         axes: Axes,
                                         alignment: Adjustement,
                                         spacing: CGFloat,
                                         maximumLineCount: Int,
                                         delay: TimeInterval,
                                         actionWhile: (() -> Void)?,
                                         actionAfter: (() -> Void)?)
    
    func createSpriteCollection(of nodes: [SKNode],
                                at startingPosition: CGPoint,
                                in node: SKNode,
                                parameter: PKGroup.Parameter)
}
