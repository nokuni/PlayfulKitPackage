//
//  File.swift
//  
//
//  Created by Maertens Yann-Christophe on 17/02/23.
//

import SpriteKit

public protocol PKMatrixProtocol {
    func createSpriteList(of nodes: [SKNode],
                          at startingPosition: CGPoint,
                          in node: SKNode,
                          axes: PKAxes,
                          alignment: PKAlignment,
                          spacing: CGFloat)
    
    func createSpriteCollectionWithDelay(of nodes: [SKSpriteNode],
                                         at startingPosition: CGPoint,
                                         in node: SKNode,
                                         axes: PKAxes,
                                         alignment: PKAlignment,
                                         spacing: CGFloat,
                                         maximumLineCount: Int,
                                         delay: TimeInterval,
                                         actionWhile: (() -> Void)?,
                                         actionAfter: (() -> Void)?)
    
    func createSpriteCollection(of nodes: [SKNode],
                                at startingPosition: CGPoint,
                                in node: SKNode,
                                parameter: PKMatrix.Parameter)
}
