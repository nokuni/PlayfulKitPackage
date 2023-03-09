//
//  SceneViewManager.swift
//  PlayfulKit
//
//  Created by Maertens Yann-Christophe on 11/08/22.
//

import SpriteKit

public struct SceneViewManager<S: RawRepresentable> {
    
    public init(currentViewState: S) {
        self.currentViewState = currentViewState
    }
    
    public var rootView = SKNode()
    public var currentView = SKNode()
    public var previousView: SKNode? = nil
    public var currentViewState: S
    public var viewCount = 0
    
    public mutating func setUpRootView(scene: SKScene) {
        if let currentViewState = currentViewState.rawValue as? String {
            scene.addChildSafely(rootView)
            rootView.name = currentViewState
            currentView = rootView
        }
    }
    public func setUpCurrentView() {
        if let currentViewState = currentViewState.rawValue as? String {
            currentView.name = currentViewState
        }
    }
    
    public mutating func goToPreviousView() {
        
        currentView.removeFromParent()
        viewCount -= 1
        
        if viewCount == 0 {
            currentView = rootView
        } else if let previousView = previousView {
            currentView = previousView
        }
    }
    
    public mutating func goToViewFromRootView(view: SKNode, viewState: S) {
        currentViewState = viewState
        view.name = viewState.rawValue as? String
        rootView.addChildSafely(view)
        viewCount += 1
        previousView = rootView
        currentView = view
    }
    
    public mutating func goToViewFromPreviousView(view: SKNode, viewState: S) {
        currentViewState = viewState
        view.name = viewState.rawValue as? String
        currentView.addChildSafely(view)
        viewCount += 1
        previousView = currentView
        currentView = view
    }
}
