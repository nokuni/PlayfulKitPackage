//
//  CameraManager.swift
//  
//
//  Created by Maertens Yann-Christophe on 04/03/23.
//

import SpriteKit

final public class CameraManager {
    
    public init(scene: SKScene? = nil,
                position: CGPoint = .center,
                zoom: CGFloat = 1) {
        self.scene = scene
        self.position = position
        self.zoom = zoom
    }

    public struct Showcase {

        public init(targetPoint: CGPoint,
                    stayDuration: CGFloat = 2,
                    moveInDuration: CGFloat = 2) {
            self.targetPoint = targetPoint
            self.stayDuration = stayDuration
            self.moveInDuration = moveInDuration
        }

        public var targetPoint: CGPoint
        public var stayDuration: CGFloat
        public var moveInDuration: CGFloat
    }
    
    public var scene: SKScene?
    public var position: CGPoint
    public var zoom: CGFloat
    
    private var previousCameraPoint = CGPoint.zero
    
    // MARK: - Public
    /// The camera follows a node constantly with a catch up delay.
    public func move(to position: CGPoint, catchUpDelay: CGFloat = 0) {
        let action = SKAction.move(to: position, duration: catchUpDelay)
        scene?.camera?.run(action)
    }

    public func showcase(_ showcase: Showcase, completion: (() -> Void)?) {
        scene?.camera?.run(showcaseAnimation(showcase, completion: completion))
    }

    /// Allow the camera to be moved on screen by gestures.
    public func gesture(_ view: SKView) {
        let panGesture = UIPanGestureRecognizer()
        panGesture.name = "Camera Gesture"
        panGesture.addTarget(self, action: #selector(gestureAction))
        view.addGestureRecognizer(panGesture)
    }

    /// Add the camera to the scene.
    public func add() {
        let cameraNode = SKCameraNode()
        
        scene?.addChildSafely(cameraNode)
        scene?.camera = cameraNode
        
        scene?.camera?.position = position
        
        let zoomAction = SKAction.scale(to: zoom, duration: 0)
        
        cameraNode.run(zoomAction)
    }
    
    // MARK: - Private
    private func showcaseAnimation(_ showcase: Showcase, completion: (() -> Void)?) -> SKAction {
        let sequence = SKAction.sequence([
            SKAction.move(to: showcase.targetPoint, duration: showcase.moveInDuration),
            SKAction.wait(forDuration: showcase.stayDuration),
            SKAction.run { completion?() }
        ])
        return sequence
    }
    @objc private func gestureAction(_ sender: UIPanGestureRecognizer) {
        // The camera has a weak reference, so test it
        guard let camera = scene?.camera else { return }
        // If the movement just began, save the first camera position
        if sender.state == .began { previousCameraPoint = camera.position }
        // Perform the translation
        let translation = sender.translation(in: scene?.view)
        let newPosition = CGPoint(
            x: previousCameraPoint.x - translation.x,
            y: previousCameraPoint.y + translation.y
        )
        camera.position = newPosition
    }
}
