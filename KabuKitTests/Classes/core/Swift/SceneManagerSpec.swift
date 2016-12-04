//
//  SceneManagerTest.swift
//  KabuKit
//
//  Created by crexista on 2016/12/04.
//  Copyright © crexista. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import KabuKit

class SceneManagerSpec: QuickSpec {
    
    class MockTransition : SceneTransition {
        typealias StageType = UIView
        
        func request(context: SceneContext<UIView>) -> SceneChangeRequest? {
            return nil
        }
    }
    
    class MockScene : NSObject, Scene {
        typealias ArgumentType = Void
        typealias TransitionType = MockTransition
        
        func onRelease(stage: UIView) -> Bool {
            return true
        }
    }
    
    override func spec() {

        describe("managerByScene") {
            SceneManager.removeAll()
            let mockScene1 = MockScene()
            let mockScene2 = MockScene()
            let obj1 = NSObject()
            let obj2 = NSObject()
            let manager = SceneManager()
            
            context("Scene1は登録し、Scene2は未登録の場合") {
                
                beforeEach {
                    manager.set(frame: mockScene1, stuff: obj1)
                }
                it("Scene1は取得できる") {
                    let result = SceneManager.managerByScene(scene: mockScene1)
                    expect(result).toNot(beNil())
                }
                
                it("Scene2は取得できない") {
                    let result = SceneManager.managerByScene(scene: mockScene2)
                    expect(result).to(beNil())
                }

            }
            
            context("Scene1、Scene2両方を同じManagerに登録している場合") {
                beforeEach {
                    manager.set(frame: mockScene1, stuff: obj1)
                    manager.set(frame: mockScene2, stuff: obj2)
                }
                it("Scene1は取得できる") {
                    let result = SceneManager.managerByScene(scene: mockScene1)
                    expect(result).toNot(beNil())
                }
                
                it("Scene2は取得できる") {
                    let result = SceneManager.managerByScene(scene: mockScene2)
                    expect(result).toNot(beNil())
                }
                it("Scene1から取得できるMangerとScene2から取得できるMangerは同じ") {
                    let result1 = SceneManager.managerByScene(scene: mockScene1)
                    let result2 = SceneManager.managerByScene(scene: mockScene2)
                    expect(result1 == result2).to(beTrue())
                }
            }
            
            context("Scene1, Scene2それぞれ違うManagerに登録されている場合") {
                let manager2 = SceneManager()
                beforeEach {
                    manager.set(frame: mockScene1, stuff: obj1)
                    manager2.set(frame: mockScene2, stuff: obj2)
                }
                it("Scene1から取得できるMangerとScene2から取得できるMangerは違う") {
                    let result1 = SceneManager.managerByScene(scene: mockScene1)
                    let result2 = SceneManager.managerByScene(scene: mockScene2)
                    expect(result1 == result2).to(beFalse())
                }

            }
        }
        

        describe("dispose") {
            let mockScene1 = MockScene()
            let mockScene2 = MockScene()
            let manager = SceneManager()
            let obj1 = NSObject()
            let obj2 = NSObject()

            context("SceneManagerにすでにSceneが登録されていた場合") {
                manager.set(frame: mockScene1, stuff: obj1)
                manager.set(frame: mockScene2, stuff: obj2)
                let result = manager.getStuff(frame: mockScene1)
                expect(result).toNot(beNil())
                
                it("disposeした後は取得できない") {
                    manager.dispose()
                    let result1 = manager.getStuff(frame: mockScene1)
                    let result2 = manager.getStuff(frame: mockScene2)
                    expect(result1).to(beNil())
                    expect(result2).to(beNil())
                }
                
            }
        }

        describe("set/getStuff") {
            let mockScene = MockScene()
            let obj = NSObject()
            SceneManager.removeAll()
            context("SceneManagerに特定のSceneをセットした場合") {
                let manager = SceneManager()
                beforeEach {
                    manager.set(frame: mockScene, stuff: obj as AnyObject)
                }
                it("Sceneに紐づくオブジェクトが取得できる") {
                    let stuff = manager.getStuff(frame: mockScene)
                    expect(stuff?.isEqual(obj)).to(beTrue())
                }
                
                it("Sceneに関係ないオブジェクトの場合は取得できない") {
                    let stuff = manager.getStuff(frame: MockScene())
                    expect(stuff).to(beNil())
                }
            }
        }

        describe("remove") {
            SceneManager.removeAll()
            let mockScene1 = MockScene()
            let mockScene2 = MockScene()
            let obj1 = NSObject()
            let obj2 = NSObject()
            let manager = SceneManager()
            
            context("2つ登録されたうち一つだけremoveする") {

                manager.set(frame: mockScene1, stuff: obj1 as AnyObject)
                manager.set(frame: mockScene2, stuff: obj2 as AnyObject)
                let stuff1 = manager.getStuff(frame: mockScene1)
                let stuff2 = manager.getStuff(frame: mockScene2)
                
                expect(stuff1?.isEqual(obj1)).to(beTrue())
                expect(stuff2?.isEqual(obj2)).to(beTrue())
                beforeEach {
                    manager.release(frame: mockScene1)
                }
                it("removeされた方のオブジェクトが取得できなくなる") {
                    let result = manager.getStuff(frame: mockScene1)
                    expect(result).to(beNil())
                }
                it("removeされていないSceneに紐づくオブジェクトは取得できる") {
                    let result = manager.getStuff(frame: mockScene2)
                    expect(result).toNot(beNil())
                    expect(stuff2?.isEqual(result)).to(beTrue())
                }
            }
        }

    }
}

