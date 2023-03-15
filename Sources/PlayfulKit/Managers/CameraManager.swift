//
//  CameraManager.swift
//  
//
//  Created by Maertens Yann-Christophe on 04/03/23.
//

import SpriteKit

final public class CameraManager {
    
    public init(scene: SKScene) {
        self.scene = scene
    }
    
    public struct CameraConfiguration {
        public init(position: CGPoint = .center,
                    zoom: CGFloat = 1) {
            self.position = position
            self.zoom = zoom
        }
        
        public var position: CGPoint
        public var zoom: CGFloat
    }
    public struct Showcase {
        
        public init(targetPoint: CGPoint,
                    moveInDuration: CGFloat = 2,
                    showDuration: CGFloat = 2,
                    afterShow: (() -> Void)?) {
            self.targetPoint = targetPoint
            self.moveInDuration = moveInDuration
            self.showDuration = showDuration
            self.afterShow = afterShow
        }
        
        public var targetPoint: CGPoint
        public var moveInDuration: CGFloat
        public var showDuration: CGFloat
        public var afterShow: (() -> Void)?
    }
    
    public var scene: SKScene
    
    private var previousCameraPoint = CGPoint.zero
    
    // MARK: - Public
    /// The camera follows a node constantly with a catch up delay.
    public func move(to position: CGPoint, catchUpDelay: CGFloat = 0) {
        let action = SKAction.move(to: position, duration: catchUpDelay)
        scene.camera?.run(action)
    }
    
    /// The camera moves to show a point for a specific duration then trigger a completion.
    public func showcase(_ showcase: Showcase) {
        scene.camera?.run(showcaseAnimation(showcase, completion: showcase.afterShow))
    }
    
    /// Allow the camera to be moved on screen by gestures.
    public func gesture(_ view: SKView) {
        let panGesture = UIPanGestureRecognizer()
        panGesture.name = "Camera Gesture"
        panGesture.addTarget(self, action: #selector(gestureAction))
        view.addGestureRecognizer(panGesture)
    }
    
    /// Configure the camera to the scene.
    public func configure(configuration: CameraConfiguration = CameraConfiguration()) {
        scene.camera?.position = configuration.position
        scene.camera?.run(zoomAction(configuration.zoom))
    }
    
    // MARK: - Private
    private func zoomAction(_ zoom: CGFloat) -> SKAction {
        SKAction.scale(to: zoom, duration: 0)
    }
    private func showcaseAnimation(_ showcase: Showcase, completion: (() -> Void)?) -> SKAction {
        let sequence = SKAction.sequence([
            SKAction.move(to: showcase.targetPoint, duration: showcase.moveInDuration),
            SKAction.wait(forDuration: showcase.showDuration),
            SKAction.run { completion?() }
        ])
        return sequence
    }
    @objc private func gestureAction(_ sender: UIPanGestureRecognizer) {
        // The camera has a weak reference, so test it
        guard let camera = scene.camera else { return }
        // If the movement just began, save the first camera position
        if sender.state == .began { previousCameraPoint = camera.position }
        // Perform the translation
        let translation = sender.translation(in: scene.view)
        let newPosition = CGPoint(
            x: previousCameraPoint.x - translation.x,
            y: previousCameraPoint.y + translation.y
        )
        camera.position = newPosition
    }
}
