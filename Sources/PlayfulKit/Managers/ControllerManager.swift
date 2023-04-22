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
    
    /// Virtual controller elements.
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
    
    /// Button symbols.
    public enum ButtonSymbol {
        case a
        case b
        case x
        case y
        case menu
    }
    
    /// Product categories.
    public enum ProductCategory {
        case xbox
        case playstation
        case nintendo
    }
    
    /// Button action.
    public struct ButtonAction {
        public init(symbol: ButtonSymbol,
                    press: (() -> Void)? = nil,
                    release: (() -> Void)? = nil) {
            self.symbol = symbol
            self.press = press
            self.release = release
        }
        
        public var symbol: ButtonSymbol
        public var press: (() -> Void)?
        public var release: (() -> Void)?
    }
    
    /// Dpad actions.
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
    
    /// Controller actions.
    public struct ControllerAction {
        public init(buttonMenu: ButtonAction = ButtonAction(symbol: .menu),
                    buttonA: ButtonAction = ButtonAction(symbol: .a),
                    buttonB: ButtonAction = ButtonAction(symbol: .b),
                    buttonX: ButtonAction = ButtonAction(symbol: .x),
                    buttonY: ButtonAction = ButtonAction(symbol: .y),
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
    
    // Variables
    public var scene: SKScene
    public var action: ControllerAction?
    public var virtualController: GCVirtualController?
    
    // Logic
    public var virtualControllerElements: [VirtualControllerElement] = []
    public var isVirtualControllerEnabled: Bool = true
    
    /// Observe the controllers and establish a connexion.
    public func observeControllers() {
        NotificationCenter.default.addObserver(self, selector: #selector(connectControllers), name: NSNotification.Name.GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectControllers), name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
        
        virtualController = GCVirtualController(configuration: virtualControllerConfiguration)
        
        if GCController.controllers().isEmpty {
            connectVirtualController()
            registerVirtualInputs()
        }
        
        guard let controller = GCController.controllers().first else { return }
        
        register(controller)
        
        connectControllers()
    }
}

// MARK: - Setup

extension ControllerManager {
    
    /// Connect controllers.
    @objc public func connectControllers() {
        print("Connect controllers ...")
        guard let controller = GCController.current else { return }
        
        if controller != virtualController?.controller {
            disconnectVirtualController()
        }
        
        register(controller)
    }
    
    /// Disconnect controllers.
    @objc public func disconnectControllers() {
        print("All Controllers disconnected ...")
        disconnectVirtualController()
        
        if GCController.controllers().isEmpty && isVirtualControllerEnabled {
            print("No Hardware controller detected ...")
            virtualController = GCVirtualController(configuration: virtualControllerConfiguration)
            connectVirtualController()
            registerVirtualInputs()
        }
    }
}

// MARK: - Utils

extension ControllerManager {
    
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
        case .menu:
            return gamepad.buttonMenu.localizedName
        }
    }
    
    /// Returns the current product category (Playstation, Xbox or Nintendo).
    public var currentProductCategory: ProductCategory? {
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
}

// MARK: - Controls

extension ControllerManager {
    
    /// Button input
    public func pressButton(_ button: GCControllerButtonInput, action: ButtonAction?) {
        button.isPressed ? action?.press?() : action?.release?()
    }
    
    /// Dpad input
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
    
    /// Register button inputs on the virtual controller.
    public func registerButton(_ button: GCControllerButtonInput?, action: ButtonAction?) {
        button?.valueChangedHandler = { button, value, isPressed in
            self.pressButton(button, action: action)
        }
    }
    
    /// Register dpad inputs on the virtual controller.
    public func registerDpad(_ dpad: GCControllerDirectionPad?) {
        guard let dpad = dpad else { return }
        dpad.valueChangedHandler = { button, value, isPressed in
            self.pressDpad(dpad, action: self.action?.dpad)
        }
    }
    
    /// Register all inputs on the virtual controller.
    public func register(_ controller: GCController?) {
        print("Register controller inputs ...")
        registerDpad(controller?.extendedGamepad?.dpad)
        
        registerButton(controller?.extendedGamepad?.buttonA, action: action?.buttonA)
        registerButton(controller?.extendedGamepad?.buttonB, action: action?.buttonB)
        registerButton(controller?.extendedGamepad?.buttonX, action: action?.buttonX)
        registerButton(controller?.extendedGamepad?.buttonY, action: action?.buttonY)
    }
    
    /// Register all inputs on the virtual controller.
    public func registerVirtualInputs() {
        print("Register virtual controller inputs ...")
        registerDpad(virtualController?.controller?.extendedGamepad?.dpad)
        
        registerButton(virtualController?.controller?.extendedGamepad?.buttonA, action: action?.buttonA)
        registerButton(virtualController?.controller?.extendedGamepad?.buttonB, action: action?.buttonB)
        registerButton(virtualController?.controller?.extendedGamepad?.buttonX, action: action?.buttonX)
        registerButton(virtualController?.controller?.extendedGamepad?.buttonY, action: action?.buttonY)
    }
}

// MARK: - Virtual Controller Setup

extension ControllerManager {
    
    /// Returns virtual controller element names (Button A, Button X, etc...)
    public var virtualControllerElementNames: Set<String> {
        let names = virtualControllerElements.map { $0.name }
        let elements = Set(names)
        return elements
    }
    
    /// Returns virtual controller configuration.
    public var virtualControllerConfiguration: GCVirtualController.Configuration {
        let configuration = GCVirtualController.Configuration()
        configuration.elements = virtualControllerElementNames
        return configuration
    }
    
    /// Enables the virtual controller.
    public func connectVirtualController() {
        print("Connect Virtual Controller ...")
        virtualController?.connect()
    }
    
    /// Disconnect the virtual controller.
    public func disconnectVirtualController() {
        print("Disconnect Virtual Controller ...")
        virtualController?.disconnect()
    }
    
    /// Disabled the virtual controller.
    public func disableVirtualController() {
        isVirtualControllerEnabled = false
    }
    
    /// Enables the virtual controller.
    public func enableVirtualController() {
        isVirtualControllerEnabled = true
    }
}

// MARK: - Haptics

extension ControllerManager {
    
    /// Trigger haptics on the hardware controller.
    public func configureHaptics(locality: GCHapticsLocality) {
        guard GCController.current != virtualController?.controller else { return }
        let controller = GCController.current
        guard let haptics = controller?.haptics else { return }
        let hapticsEngine = haptics.createEngine(withLocality: locality)
        do {
            try hapticsEngine?.start()
        } catch let error {
            print("Failed to play haptic pattern: \(error.localizedDescription).")
        }
    }
    
    public func triggerHaptics() {
        let haptic = HapticsManager()
        haptic.complexSuccess(intensity: 0.5, sharpness: 0.5)
    }
}
