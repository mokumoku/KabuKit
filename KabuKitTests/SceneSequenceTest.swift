//
//  Copyright © 2017年 DWANGO Co., Ltd.
//

import XCTest
@testable import KabuKit

class SceneSequenceTest: XCTestCase {
    
    let stage: MockStage = MockStage()
    
    let firstScene: MockFirstScene = MockFirstScene()
    
    let guide = MockGuide()
    
    var sequence: SceneSequence<Void, MockGuide>?
    
    override func setUp() {
        super.setUp()
        sequence = SceneSequence<Void, MockGuide>(guide)

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // rewindイベントが呼び出されたかどうかの状態を初期化
        self.guide.wasRunRewindHandler = false
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_FirstSceneからScenarioRequest1を受けたらcalledFirstToFirstが呼ばれそのあとrollbackが呼ばれたらresetされる() {
        let request = MockScenarioRequest1()
        let asyncExpection: XCTestExpectation? = self.expectation(description: "wait")
        
        XCTAssertFalse(self.guide.calledFirstToFirst)
        sequence?.startWith(stage, firstScene, ()) { (scene, stage) in
            stage.setScene(scene: scene)
            self.firstScene.send(request, { (completion) in
                XCTAssertTrue(completion)
                XCTAssertTrue(self.guide.calledFirstToFirst)
                asyncExpection?.fulfill()
            })
        }

        self.wait(for: [asyncExpection!], timeout: 2.0)
    }
    
    func test_FirstSceneからRequestを受け指定のSceneに遷移したのち指定のSceneでleaveが呼ばれたら戻ってこれる() {
        let request = MockScenarioRequest3()
        let asyncExpection: XCTestExpectation? = self.expectation(description: "wait")
        XCTAssertFalse(self.guide.calledFirstToFirst)
        sequence?.startWith(stage, firstScene, ()) { (scene, stage) in
            stage.setScene(scene: scene)
            self.firstScene.send(request, { (completion) in
                XCTAssertTrue(completion)
                XCTAssertTrue(self.guide.calledFirstToSecond)
                self.guide.tmpSecondScene.leave() {(completion) in
                    XCTAssertFalse(self.guide.calledFirstToSecond)
                    asyncExpection?.fulfill()
                }
            })
        }
        
        self.wait(for: [asyncExpection!], timeout: 2.0)

    }

    /**
     Tests for leave()
     */
    func test_leaveが引数無しで呼び出された場合にはrewindイベントが実行される() {
        let request = MockScenarioRequest3()
        let asyncExpection: XCTestExpectation? = self.expectation(description: "wait")

        sequence?.startWith(stage, firstScene, ()) { (scene, stage) in
            stage.setScene(scene: scene)
            self.firstScene.send(request, { (completion) in
                self.guide.tmpSecondScene.leave()

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    XCTAssertTrue(self.guide.wasRunRewindHandler)
                    asyncExpection?.fulfill()
                }
            })
        }

        self.wait(for: [asyncExpection!], timeout: 2.0)
    }

    /**
     Tests for leave(_ runTransition:)
     */
    func leaveTest(runTransition: Bool, wasRunRewindHandlerExpectation: Bool) -> Void {
        let request = MockScenarioRequest3()
        let asyncExpection: XCTestExpectation? = self.expectation(description: "wait")

        sequence?.startWith(stage, firstScene, ()) { (scene, stage) in
            stage.setScene(scene: scene)
            self.firstScene.send(request, { (completion) in
                self.guide.tmpSecondScene.leave(runTransition)

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    if wasRunRewindHandlerExpectation {
                        XCTAssertTrue(self.guide.wasRunRewindHandler)
                    } else {
                        XCTAssertFalse(self.guide.wasRunRewindHandler)
                    }
                    asyncExpection?.fulfill()
                }
            })
        }

        self.wait(for: [asyncExpection!], timeout: 2.0)
    }

    func test_leaveが引数trueで呼び出された場合にはrewindイベントが実行される() {
        self.leaveTest(runTransition: true, wasRunRewindHandlerExpectation: true)
    }

    func test_leaveが引数falseで呼び出された場合にはrewindイベントが実行されない() {
        self.leaveTest(runTransition: false, wasRunRewindHandlerExpectation: false)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}