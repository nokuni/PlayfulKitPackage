//
//  ControllerManager.swift
//  
//
//  Created by Maertens Yann-Christophe on 06/03/23.
//

import SpriteKit
import GameController

/// Manage and configure your game controllers.
public class ControllerManager {
    
    public init(scene: SKScene) {
        self.scene = scene
    }
    
    public enum VirtualControllerElement {
        case leftThumbstick
        case rightThumbstick
        case directionPad
        case buttonA
        case buttonB
        case buttonX
        case buttonY
        
        var name: String {
            switch self {
            case .leftThumbstick:
                return GCInputLeftThumbstick
            case .rightThumbstick:
                return GCInputRightThumbstick
            case .directionPad:
                return GCInputDirectionPad
            case .buttonA:
                return GCInputButtonA
            case .buttonB:
                return GCInputButtonB
            case .buttonX:
                return GCInputButtonX
            case .buttonY:
                return GCInputButtonY
            }
        }
    }
    public struct DirectionPadAction {
        public  init(left: @escaping (() -> Void),
                     right: @escaping (() -> Void),
                     up: @escaping (() -> Void),
                     down: @escaping (() -> Void)) {
            self.left = left
            self.right = right
            self.up = up
            self.down = down
        }
        
        var left: (() -> Void)
        var right: (() -> Void)
        var up: (() -> Void)
        var down: (() -> Void)
    }
    
    public var scene: SKScene
    
    public var buttonMenu: (() -> Void)?
    public var buttonA: (() -> Void)?
    public var buttonB: (() -> Void)?
    public var buttonX: (() -> Void)?
    public var buttonY: (() -> Void)?
    public var padAction: DirectionPadAction?
    public var virtualControllerElements: [VirtualControllerElement] = []
    
    private var virtualController: GCVirtualController?
    private var virtualControllerElementNames: Set<String> {
        let names = virtualControllerElements.map { $0.name }
        let elements = Set(names)
        return elements
    }
    
    public func observeControllers() {
        NotificationCenter.default.addObserver(self, selector: #selector(connectControllers), name: NSNotification.Name.GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectControllers), name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
    }
    
    @objc private func connectControllers(notification: Notification) {
        scene.isPaused = false
        if let controller = notification.object as? GCController {
            setupControllerControls(controller: controller)
        } else {
            connectVirtualController()
        }
    }
    @objc private func disconnectControllers(notification: Notification) {
        scene.isPaused = true
        if GCController.controllers().isEmpty {
            connectVirtualController()
        }
    }
    
    private func connectVirtualController() {
        // Connect to the virtual controller if no physical controllers are available.
        if GCController.controllers().isEmpty {
            let virtualConfiguration = GCVirtualController.Configuration()
            virtualConfiguration.elements = virtualControllerElementNames
            virtualController = GCVirtualController(configuration: virtualConfiguration)
            virtualController?.connect()
        }
    }
    
    // MARK: - Controller Controls
    private func setupControllerControls(controller: GCController) {
        controller.extendedGamepad?.valueChangedHandler = {
            (gamepad: GCExtendedGamepad, element: GCControllerElement) in
            self.controllerInputDetected(gamepad: gamepad, element: element, index: controller.playerIndex.rawValue)
        }
    }
    private func pressButton(_ button: GCControllerButtonInput, action: (() -> Void)) {
        if button.isPressed { action() }
    }
    private func pressDpad(_ directionPad: GCControllerDirectionPad,
                                action: DirectionPadAction?) {
        if directionPad.right.isPressed && !directionPad.left.isPressed { action?.left() }
        if directionPad.left.isPressed && !directionPad.right.isPressed { action?.right() }
        
        if directionPad.up.isPressed && !directionPad.down.isPressed { action?.up() }
        if directionPad.down.isPressed && !directionPad.up.isPressed { action?.down() }
    }
    private func controllerInputDetected(gamepad: GCExtendedGamepad,
                                         element: GCControllerElement,
                                         index: Int) {
        pressButton(gamepad.buttonMenu) { buttonMenu?() }
        pressButton(gamepad.buttonA) { buttonA?() }
        pressButton(gamepad.buttonB) { buttonB?() }
        pressButton(gamepad.buttonX) { buttonX?() }
        pressButton(gamepad.buttonY) { buttonY?()}
        pressDpad(gamepad.dpad, action: padAction)
    }
}
