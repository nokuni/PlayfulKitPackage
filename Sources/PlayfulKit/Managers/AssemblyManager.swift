//
//  Assembly.swift
//  PlayfulKit
//
//  Created by Maertens Yann-Christophe on 05/11/22.
//

import SpriteKit

final public class AssemblyManager {
    
    public init() { }
    
    public struct Parameter {
        public init(axes: Axes = .horizontal,
                    alignment: Adjustement = .leading,
                    horizontalSpacing: CGFloat = 1,
                    verticalSpacing: CGFloat = 1,
                    columns: Int = 2) {
            self.axes = axes
            self.alignment = alignment
            self.horizontalSpacing = horizontalSpacing
            self.verticalSpacing = verticalSpacing
            self.columns = columns
        }
        var axes: Axes
        var alignment: Adjustement
        var horizontalSpacing: CGFloat
        var verticalSpacing: CGFloat
        var columns: Int
    }
    
    private func centerAlignmentPosition(from nodes: [SKNode],
                                         with spacing: CGFloat) -> CGFloat {
        guard !nodes.isEmpty else { return 0 }
        let nodeSize = nodes.first!.frame.size.width
        let dividerValue = (spacing / (spacing / 2) / spacing)
        let nodeHalfSize: CGFloat = nodeSize / dividerValue
        let nodeCount = nodes.count
        let gap = nodeHalfSize * (CGFloat(nodeCount) - 1)
        
        return -gap
    }
    
    private func initialListPosition(from nodes: [SKNode],
                                     on startingPosition: CGPoint,
                                     with alignment: Adjustement,
                                     and spacing: CGFloat) -> CGPoint {
        let centerAlignmentValue = centerAlignmentPosition(from: nodes, with: spacing)
        
        var initialPosition: CGPoint = CGPoint.zero
        
        switch alignment {
        case .center:
            initialPosition = CGPoint(x: centerAlignmentValue, y: startingPosition.y)
        case .leading:
            initialPosition = startingPosition
        case .trailing:
            initialPosition = startingPosition
        }
        
        return initialPosition
    }
    
    private func axesIncrementedValue(axes: Axes,
                                      alignment: Adjustement,
                                      node: SKNode,
                                      position: CGPoint,
                                      spacing: CGFloat) -> CGPoint {
        switch axes {
        case .horizontal:
            switch alignment {
            case .center:
                return CGPoint(x: position.x + (node.frame.size.width * spacing),
                               y: position.y)
            case .leading:
                return CGPoint(x: position.x + (node.frame.size.width * spacing),
                               y: position.y)
            case .trailing:
                return CGPoint(x: position.x - (node.frame.size.width * spacing),
                               y: position.y)
            }
        case .vertical:
            return CGPoint(x: position.x,
                           y: position.y - (node.frame.size.height * spacing))
        }
    }
    
    /// Create a list of sprites
    public func createSpriteList(of nodes: [SKNode],
                                 at startingPosition: CGPoint = .zero,
                                 in node: SKNode,
                                 axes: Axes = .vertical,
                                 alignment: Adjustement = .leading,
                                 spacing: CGFloat = 1) {
        guard !nodes.isEmpty else { return }
        var nodes = nodes
        nodes.reserveCapacity(nodes.count)
        var initialPosition = initialListPosition(from: nodes, on: startingPosition, with: alignment, and: spacing)
        for index in nodes.indices {
            nodes[index].position = initialPosition
            node.addChild(nodes[index])
            initialPosition = axesIncrementedValue(axes: axes, alignment: alignment, node: nodes[index], position: initialPosition, spacing: spacing)
        }
    }
    
    /// Create a collection of sprite nodes delayed on each sprite node creation.
    public func createSpriteCollectionWithDelay(of nodes: [SKSpriteNode],
                                                at startingPosition: CGPoint = .zero,
                                                in node: SKNode,
                                                axes: Axes = .horizontal,
                                                alignment: Adjustement = .leading,
                                                spacing: CGFloat = 1,
                                                maximumLineCount: Int = 2,
                                                delay: TimeInterval = 0.5,
                                                actionWhile: (() -> Void)?,
                                                actionAfter: (() -> Void)?) {
        guard !nodes.isEmpty else { return }
        
        var timer: Timer?
        var count = 0
        
        var nodes = nodes
        nodes.reserveCapacity(nodes.count)
        let firstPosition = initialListPosition(from: nodes, on: startingPosition, with: alignment, and: spacing)
        var initialPosition = firstPosition
        
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: true, block: { timer in
            if count < nodes.count {
                actionWhile?()
                nodes[count].position = initialPosition
                node.addChild(nodes[count])
                let updatedPosition = self.axesIncrementedValue(axes: axes, alignment: alignment, node: nodes[count], position: initialPosition, spacing: spacing)
                initialPosition = updatedPosition
                if (count + 1) % maximumLineCount == 0 {
                    initialPosition.y -= nodes.first!.frame.size.height
                    initialPosition.x = firstPosition.x
                }
                count += 1
            } else {
                timer.invalidate()
                actionAfter?()
            }
        })
        
        timer?.fire()
    }
    
    /// Create a collection of sprite nodes
    public func createSpriteCollection(of nodes: [SKNode],
                                       at startingPosition: CGPoint = .zero,
                                       in node: SKNode,
                                       parameter: AssemblyManager.Parameter = AssemblyManager.Parameter()) {
        
        guard !nodes.isEmpty else { return }
        
        let firstPosition = initialListPosition(from: nodes, on: startingPosition, with: parameter.alignment, and: parameter.horizontalSpacing)
        var initialPosition = firstPosition
        var nodes = nodes
        nodes.reserveCapacity(nodes.count)
        
        for index in nodes.indices {
            addCollectionNode(index: index, node: node, nodes: nodes, parameter: parameter, firstPosition: firstPosition, position: &initialPosition)
        }
    }
    
    private func addCollectionNode(index: Int,
                                   node: SKNode,
                                   nodes: [SKNode],
                                   parameter: AssemblyManager.Parameter,
                                   firstPosition: CGPoint,
                                   position: inout CGPoint) {
        nodes[index].position = position
        node.addChild(nodes[index])
        let updatedPosition = axesIncrementedValue(axes: parameter.axes, alignment: parameter.alignment, node: nodes[index], position: position, spacing: parameter.horizontalSpacing)
        position = updatedPosition
        if (index + 1) % parameter.columns == 0 {
            position.y -= (nodes.first!.frame.size.height * parameter.verticalSpacing)
            position.x = firstPosition.x
        }
    }
}
