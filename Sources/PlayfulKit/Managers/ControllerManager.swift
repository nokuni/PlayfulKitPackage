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
    public enum ButtonSymbol {
        case a
        case b
        case x
        case y
    }
    public enum ProductCategory {
        case xbox
        case playstation
        case nintendo
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
        public  init(leftPress: (() -> Void)? = nil,
                     rightPress: (() -> Void)? = nil,
                     upPress: (() -> Void)? = nil,
                     downPress: (() -> Void)? = nil,
                     release: (() -> Void)? = nil) {
            self.leftPress = leftPress
            self.rightPress = rightPress
            self.upPress = upPress
            self.downPress = downPress
            self.release = release
        }
        
        var leftPress: (() -> Void)?
        var rightPress: (() -> Void)?
        var upPress: (() -> Void)?
        var downPress: (() -> Void)?
        var release: (() -> Void)?
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
    
    public func removeControllerObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Observe the controllers and establish a connexion.
    public func observeControllers() {
        NotificationCenter.default.addObserver(self, selector: #selector(connectControllers), name: NSNotification.Name.GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectControllers), name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
        
        virtualController = GCVirtualController(configuration: virtualControllerConfiguration)
        
        if GCController.controllers().isEmpty {
            print("Virtual Controller connected !")
            connectVirtualController()
            registerVirtualInputs()
        }
        
        guard let controller = GCController.controllers().first else { return }
        
        register(controller)
        
        connectControllers()
    }
    
    /// Name of the button
    public func buttonName(_ symbol: ButtonSymbol) -> String? {
        guard let gamepad = GCController.current?.extendedGamepad else { return nil }
        switch symbol {
        case .a:
            return gamepad.buttonA.localizedName
        case .b:
            return gamepad.buttonB.localizedName
        case .x:
            return gamepad.buttonX.localizedName
        case .y:
            return gamepad.buttonY.localizedName
        }
    }
    public var currentProductCategory: ProductCategory? {
        // "Nintendo Switch Joy-Con (L/R)" -> Nintendo
        // DualShock -> Playstation
        // DualSense -> Playstation
        // ??? -> Xbox
        let productCategory = GCController.current?.productCategory
        
        guard let productCategory = productCategory else { return nil }
        
        switch true {
        case productCategory.localizedCaseInsensitiveContains("joy-con"):
            return .nintendo
        case productCategory.localizedCaseInsensitiveContains("dualshock"):
            return .playstation
        case productCategory.localizedCaseInsensitiveContains("dualsense"):
            return .playstation
        case productCategory.localizedCaseInsensitiveContains("xbox"):
            return .xbox
        default:
            return nil
        }
    }
    
    // MARK: - Setup
    @objc public func connectControllers() {
        guard let controller = GCController.current else { return }
        
        if controller != virtualController?.controller {
            print("Virtual Controller disconnected ...")
            disconnectVirtualController()
        }
        
        register(controller)
    }
    @objc public func disconnectControllers() {
        print("Hardware and Virtual Controller disconnected ...")
        disconnectVirtualController()
        
        if GCController.controllers().isEmpty {
            virtualController = GCVirtualController(configuration: virtualControllerConfiguration)
            connectVirtualController()
            registerVirtualInputs()
        }
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
        virtualController?.connect()
    }
    public func disconnectVirtualController() {
        virtualController?.disconnect()
    }
    
    // MARK: - Controls
    public func register(_ controller: GCController?) {
        print("Register Controller ...")
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
        switch true {
        case directionPad.right.isPressed && !directionPad.left.isPressed:
            action?.rightPress?()
        case directionPad.left.isPressed && !directionPad.right.isPressed:
            action?.leftPress?()
        case directionPad.up.isPressed && !directionPad.down.isPressed:
            action?.upPress?()
        case directionPad.down.isPressed && !directionPad.up.isPressed:
            action?.downPress?()
        default:
            action?.release?()
        }
    }
    public func input(on gamepad: GCExtendedGamepad) {
        pressButton(gamepad.buttonMenu, action: action?.buttonMenu)
        pressButton(gamepad.buttonA, action: action?.buttonA)
        pressButton(gamepad.buttonB, action: action?.buttonB)
        pressButton(gamepad.buttonX, action: action?.buttonX)
        pressButton(gamepad.buttonY, action: action?.buttonY)
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
