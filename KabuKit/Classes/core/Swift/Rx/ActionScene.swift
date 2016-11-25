//
//  ActionScene.swift
//  KabuKit
//
//  Created by crexista on 2016/11/17.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation

public protocol ActionScene : Scene {
    var actor: Actor { get }
}

extension ActionScene {
    
    public var actor: Actor {
        return FrameStore.actors.object(forKey: self as AnyObject) as! Actor
    }
    
    internal func set(actor: Actor) {
        FrameStore.actors.setObject(actor, forKey: self as AnyObject)
    }
    
}

extension Frame where Self: ActionScene {
    
    public func setup(stage: AnyObject, container: FrameContainer, scenario: Scenario?) {
        set(transition: SceneTransition<linkType>(stage, container, scenario))
        set(actor: Actor())
    }

    public func close() {
        let actor = FrameStore.actors.object(forKey: self as AnyObject) as! Actor
        actor.terminate()
        FrameStore.transitions.removeObject(forKey: self as AnyObject)        
        FrameStore.actors.removeObject(forKey: self as AnyObject)
        FrameStore.contexts.removeObject(forKey: self as AnyObject)
    }

}