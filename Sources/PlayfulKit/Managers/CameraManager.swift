//
//  CameraManager.swift
//  
//
//  Created by Maertens Yann-Christophe on 04/03/23.
//

import SpriteKit

final public class CameraManager {
    
    public init(scene: SKScene,
                position: CGPoint = .center,
                zoom: CGFloat = 1,
                catchUpDelay: CGFloat = 0) {
        self.scene = scene
        self.position = position
        self.zoom = zoom
        self.catchUpDelay = catchUpDelay
        
        setUpCamera()
    }
    
    public var scene: SKScene
    public var position: CGPoint
    public var zoom: CGFloat
    public var catchUpDelay: CGFloat
    
    private var previousCameraPoint = CGPoint.zero
    
    // MARK: - Public
    /// Move the camera to a specific position.
    public func move(to position: CGPoint) {
        guard scene.isExistingChildNode(named: "Player") else { return }
        scene.camera?.run(SKAction.move(to: position, duration: catchUpDelay))
    }
    /// Allow the camera to be moved on screen by gestures.
    public func cameraGesture(_ view: SKView) {
        let panGesture = UIPanGestureRecognizer()
        panGesture.name = "Camera Gesture"
        panGesture.addTarget(self, action: #selector(cameraGestureAction))
        view.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Private
    private func setUpCamera() {
        let cameraNode = SKCameraNode()
        
        scene.addChild(cameraNode)
        scene.camera = cameraNode
        
        scene.camera?.position = position
        
        let zoomAction = SKAction.scale(to: zoom, duration: 0)
        
        cameraNode.run(zoomAction)
    }
    @objc private func cameraGestureAction(_ sender: UIPanGestureRecognizer) {
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
