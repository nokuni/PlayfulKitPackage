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
    
    public struct ButtonAction {
        public init(press: (() -> Void)? = nil, release: (() -> Void)? = nil) {
            self.press = press
            self.release = release
        }
        
        public var press: (() -> Void)?
        public var release: (() -> Void)?
    }
    public struct DPadAction {
        public  init(left: (() -> Void)?,
                     right: (() -> Void)?,
                     up: (() -> Void)?,
                     down: (() -> Void)?) {
            self.left = left
            self.right = right
            self.up = up
            self.down = down
        }
        
        var left: (() -> Void)?
        var right: (() -> Void)?
        var up: (() -> Void)?
        var down: (() -> Void)?
    }
    
    public struct ControllerAction {
        public init(buttonMenu: ButtonAction = ButtonAction(),
                    buttonA: ButtonAction = ButtonAction(),
                    buttonB: ButtonAction = ButtonAction(),
                    buttonX: ButtonAction = ButtonAction(),
                    buttonY: ButtonAction = ButtonAction(),
                    dpad: DPadAction? = nil) {
            self.buttonMenu = buttonMenu
            self.buttonA = buttonA
            self.buttonB = buttonB
            self.buttonX = buttonX
            self.buttonY = buttonY
            self.dpad = dpad
        }
        
        public var buttonMenu: ButtonAction
        public var buttonA: ButtonAction
        public var buttonB: ButtonAction
        public var buttonX: ButtonAction
        public var buttonY: ButtonAction
        public var dpad: DPadAction?
    }
    
    public var virtualController: GCVirtualController?
    
    public var scene: SKScene
    public var action: ControllerAction?
    public var virtualControllerElements: [VirtualControllerElement] = []
    
    /// Observe the controllers and establish a connexion.
    public func observeControllers() {
        NotificationCenter.default.addObserver(forName: .GCControllerDidConnect, object: nil, queue: .main) { notification in
            if let controller = notification.object as? GCController {
                print("Hardware Controller Registered")
                self.register(controller)
            }
        }
        
        NotificationCenter.default.addObserver(forName: .GCControllerDidDisconnect, object: nil, queue: .main) { notification in
            if notification.object is GCController {
                self.disconnectControllers()
            }
        }
//        NotificationCenter.default.addObserver(self, selector: #selector(connectControllers), name: NSNotification.Name.GCControllerDidConnect, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(disconnectControllers), name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
        
//        if GCController.controllers().isEmpty {
//            virtualController = GCVirtualController(configuration: virtualControllerConfiguration)
//            connectVirtualController()
//            registerVirtualInputs()
//        }
//
//        guard let controller = GCController.controllers().first else { return }
//
//        register(controller)
    }
    
    // MARK: - Setup
    @objc public func connectControllers() {
        guard let controller = GCController.controllers().first else { return }
        if controller != virtualController?.controller { virtualController?.disconnect() }
        print("Hardware Controller connected !")
        register(controller)
    }
    
    @objc public func disconnectControllers() {
        print("Hardware Controller disconnected ...")
        print("Virtual Controller created ...")
        virtualController = GCVirtualController(configuration: virtualControllerConfiguration)
        connectVirtualController()
        registerVirtualInputs()
    }
    
    // MARK: - Virtual
    public var virtualControllerElementNames: Set<String> {
        let names = virtualControllerElements.map { $0.name }
        let elements = Set(names)
        return elements
    }
    public var virtualControllerConfiguration: GCVirtualController.Configuration {
        let configuration = GCVirtualController.Configuration()
        configuration.elements = virtualControllerElementNames
        return configuration
    }
    public func connectVirtualController() {
        print("Virtual Controller Connected !")
        virtualController?.connect()
    }
    public func disconnectVirtualController() {
        print("Virtual Controller Disconnected ...")
        virtualController?.disconnect()
    }
    
    // MARK: - Controls
    public func register(_ controller: GCController?) {
        controller?.extendedGamepad?.valueChangedHandler = {
            (gamepad: GCExtendedGamepad, element: GCControllerElement) in
            self.input(on: gamepad)
        }
    }
    public func pressButton(_ button: GCControllerButtonInput, action: ButtonAction?) {
        if button.isPressed { action?.press?() } else { action?.release?() }
    }
    public func pressDpad(_ directionPad: GCControllerDirectionPad,
                          action: DPadAction?) {
        if directionPad.right.isPressed && !directionPad.left.isPressed { action?.right?() }
        if directionPad.left.isPressed && !directionPad.right.isPressed { action?.left?() }
        
        if directionPad.up.isPressed && !directionPad.down.isPressed { action?.up?() }
        if directionPad.down.isPressed && !directionPad.up.isPressed { action?.down?() }
    }
    public func input(on gamepad: GCExtendedGamepad) {
        pressButton(gamepad.buttonMenu, action: action?.buttonMenu)
        pressButton(gamepad.buttonA, action: action?.buttonA)
        pressButton(gamepad.buttonB, action: action?.buttonA)
        pressButton(gamepad.buttonX, action: action?.buttonA)
        pressButton(gamepad.buttonY, action: action?.buttonA)
        pressDpad(gamepad.dpad, action: action?.dpad)
    }
    
    public func registerButton(_ button: GCControllerButtonInput?, action: ButtonAction?) {
        button?.valueChangedHandler = { button, value, isPressed in
            self.pressButton(button, action: action)
        }
    }
    public func registerDpad(_ dpad: GCControllerDirectionPad?) {
        guard let dpad = dpad else { return }
        dpad.valueChangedHandler = { button, value, isPressed in
            self.pressDpad(dpad, action: self.action?.dpad)
        }
    }
    public func registerVirtualInputs() {
        registerDpad(virtualController?.controller?.extendedGamepad?.dpad)
        
        registerButton(virtualController?.controller?.extendedGamepad?.buttonA, action: action?.buttonA)
        registerButton(virtualController?.controller?.extendedGamepad?.buttonB, action: action?.buttonB)
        registerButton(virtualController?.controller?.extendedGamepad?.buttonX, action: action?.buttonX)
        registerButton(virtualController?.controller?.extendedGamepad?.buttonY, action: action?.buttonY)
    }
}
