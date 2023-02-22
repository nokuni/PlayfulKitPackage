//
//  AnimationManager.swift
//  PlayfulKit
//
//  Created by Maertens Yann-Christophe on 11/08/22.
//

import SpriteKit

public class AnimationManager {
    
    public init() { }
    
    public func start(actionBeforeAnimation: (() -> Void)? = nil,
                      with animation: SKAction,
                      on node: SKNode,
                      and actionAfterAnimation: (() -> Void)? = nil) {
        let group = DispatchGroup()
        group.enter()
        actionBeforeAnimation?()
        node.run(animation) { group.leave() }
        group.notify(queue: .main) { actionAfterAnimation?() }
    }
}
