//
//  PKMatrix.swift
//  PlayfulKit
//
//  Created by Maertens Yann-Christophe on 05/11/22.
//

import SpriteKit

public class PKMatrix {
    public init() { }
    
    public enum PKAxes {
        case horizontal
        case vertical
    }
    
    public enum PKAlignment {
        case center
        case leading
        case trailing
    }
    
    public struct Coordinate {
        public init(
            x: Int = 0,
            y: Int = 0) {
                self.x = x
                self.y = y
            }
        var x: Int = 0
        var y: Int = 0
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
                                     with alignment: PKAlignment,
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
    
    private func axesIncrementedValue(axes: PKAxes,
                                      alignment: PKAlignment,
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
    
    private func addCollectionNode(index: Int,
                                   nodes: [SKNode],
                                   node: SKNode,
                                   axes: PKAxes,
                                   alignment: PKAlignment,
                                   position: inout CGPoint,
                                   firstPosition: CGPoint,
                                   horizontalSpacing: CGFloat,
                                   verticalSpacing: CGFloat,
                                   maximumLineCount: Int) {
        nodes[index].position = position
        node.addChild(nodes[index])
        let updatedPosition = axesIncrementedValue(axes: axes, alignment: alignment, node: nodes[index], position: position, spacing: horizontalSpacing)
        position = updatedPosition
        if (index + 1) % maximumLineCount == 0 {
            position.y -= (nodes.first!.frame.size.height * verticalSpacing)
            position.x = firstPosition.x
        }
    }
    
    private func addMapNode(index: Int,
                            of nodes: [SKNode],
                            at startingPosition: CGPoint = .zero,
                            in node: SKNode,
                            squareSize: CGSize,
                            axes: PKAxes = .horizontal,
                            alignment: PKAlignment = .leading,
                            position: inout CGPoint,
                            firstPosition: CGPoint,
                            coordinate: inout Coordinate,
                            horizontalSpacing: CGFloat = 1,
                            verticalSpacing: CGFloat = 1,
                            maximumLineCount: Int = 2) {
        nodes[index].name = "x\(coordinate.x) y\(coordinate.y)"
        nodes[index].position = position
        node.addChild(nodes[index])
        let updatedPosition = axesIncrementedValue(axes: axes, alignment: alignment, node: nodes[index], position: position, spacing: horizontalSpacing)
        position = updatedPosition
        coordinate.y += 1
        if (index + 1) % maximumLineCount == 0 {
            position.y -= (nodes.first!.frame.size.height * verticalSpacing)
            position.x = firstPosition.x
            coordinate.x += 1
            coordinate.y = 0
        }
    }
    
    // Create a list of sprites
    public func createSpriteList(of nodes: [SKNode],
                                 at startingPosition: CGPoint = .zero,
                                 in node: SKNode,
                                 axes: PKAxes = .vertical,
                                 alignment: PKAlignment = .leading,
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
    
    // Create a collection of sprite nodes delayed on each sprite node creation.
    public func createSpriteCollectionWithDelay(of nodes: [SKSpriteNode],
                                                at startingPosition: CGPoint = .zero,
                                                in node: SKNode,
                                                axes: PKAxes = .horizontal,
                                                alignment: PKAlignment = .leading,
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
    
    // Create a collection of sprite nodes
    public func createSpriteCollection(of nodes: [SKNode],
                                       at startingPosition: CGPoint = .zero,
                                       in node: SKNode,
                                       axes: PKAxes = .horizontal,
                                       alignment: PKAlignment = .leading,
                                       horizontalSpacing: CGFloat = 1,
                                       verticalSpacing: CGFloat = 1,
                                       maximumLineCount: Int = 2) {
        
        guard !nodes.isEmpty else { return }
        
        let firstPosition = initialListPosition(from: nodes, on: startingPosition, with: alignment, and: horizontalSpacing)
        var initialPosition = firstPosition
        var nodes = nodes
        nodes.reserveCapacity(nodes.count)
        for index in nodes.indices {
            addCollectionNode(index: index, nodes: nodes, node: node, axes: axes, alignment: alignment, position: &initialPosition, firstPosition: firstPosition, horizontalSpacing: horizontalSpacing, verticalSpacing: verticalSpacing, maximumLineCount: maximumLineCount)
        }
    }
    
#warning("To improve")
    public func createMap(of amount: Int,
                          at startingPosition: CGPoint = .zero,
                          in node: SKNode,
                          hasTexture: Bool,
                          squareSize: CGSize,
                          axes: PKAxes = .horizontal,
                          alignment: PKAlignment = .leading,
                          horizontalSpacing: CGFloat = 1,
                          verticalSpacing: CGFloat = 1,
                          maximumLineCount: Int = 2) {
        guard amount > 0 else { return }
        var squares: [SKSpriteNode] = []
        for _ in 0..<amount {
            let coordinateSquare = SKSpriteNode()
            coordinateSquare.texture = hasTexture ? SKTexture(imageNamed: "square") : nil
            coordinateSquare.size = squareSize
            squares.append(coordinateSquare)
        }
        var coordinate: Coordinate = Coordinate()
        let firstPosition = initialListPosition(from: squares, on: startingPosition, with: alignment, and: horizontalSpacing)
        var initialPosition = firstPosition
        squares.reserveCapacity(amount)
        for index in squares.indices {
            addMapNode(index: index, of: squares, in: node, squareSize: squareSize, position: &initialPosition, firstPosition: firstPosition, coordinate: &coordinate, maximumLineCount: maximumLineCount)
            
        }
    }
    
    public func addTextureOnMapSquare(_ image: String,
                                      filteringMode: SKTextureFilteringMode = .linear,
                                      on node: SKNode,
                                      at coordinate: Coordinate) {
        if let mapSquare = node.childNode(withName: "\(coordinate.x) \(coordinate.y)") as? SKSpriteNode {
            mapSquare.texture = SKTexture(imageNamed: image)
            mapSquare.texture?.filteringMode = filteringMode
        }
    }
    
    public func coordinate(from node: SKNode) -> Coordinate {
        let coordinateNames = node.name?.components(separatedBy: " ")
        guard let xName = coordinateNames?.first else { return Coordinate() }
        guard let yName = coordinateNames?.last else { return Coordinate() }
        guard let xValue = Int(xName) else { return Coordinate() }
        guard let yValue = Int(yName) else { return Coordinate() }
        print("Coordinate has been acquired")
        return Coordinate(x: xValue, y: yValue)
    }
    
    public func squares(_ node: SKNode, from row: Int) -> [SKNode] {
        let nodes = node.children
        let squareRow = nodes.filter { coordinate(from: $0).x == row }
        return squareRow
    }
    
    public func fillMapRow(from node: SKNode, with image: String, filteringMode: SKTextureFilteringMode = .linear, row: Int) {
        let nodes = squares(node, from: row)
        for node in nodes {
            if let node = node as? SKSpriteNode {
                node.texture = SKTexture(imageNamed: image)
                node.texture?.filteringMode = filteringMode
            }
        }
    }
    
    public func fillMap(_ node: SKNode, with image: String) {
        let nodes = node.children
        for index in nodes.indices {
            fillMapRow(from: node, with: image, filteringMode: .nearest, row: index)
        }
    }
}
