//
//  Sample2BScene.swift
//  Example
//
//  Created by crexista on 2016/11/25.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation
import KabuKit

extension Sample2BViewController: ActionScene {
    
    typealias ContextType = Bool
    typealias TransitionType = Sample2Link

    enum Sample2Link: SceneTransition {
        typealias StageType = UIViewController
        case A, B
        
        public func request(factory: SceneChangeRequestFactory<UIViewController>) -> SceneChangeRequest? {
            switch self {
            case .A:
                let File2A = ViewControllerXIBFile("Sample2AViewController", Bundle.main)
                return factory.createSceneChangeRequest(File2A, Sample2AViewController.self, true) { (stage, scene) in
                    stage.navigationController?.pushViewController(scene, animated: true)
                }
            case .B:
                let File2B = ViewControllerXIBFile("Sample2BViewController", Bundle.main)
                return factory.createSceneChangeRequest(File2B, Sample2BViewController.self, true) { (stage, scene) in
                    stage.navigationController?.pushViewController(scene, animated: true)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        let action = Sample2BAction(nextButtonA: nextButtonA, nextButtonB: nextButtonB, prevButton: prevButton)
        actor.activate(action: action, director: director, context: context)
    }
    
    /**
     前の画面への遷移リクエストが飛んできたときに呼ばれるメソッドです
     このメソッドが返すSceneBackRequestのexecuteが呼ばれた際にtrueを返すとこの画面のに紐づくメモリが解放されます
     
     - Parameter factory: 前の画面への遷移リクエストを生成するインスタンスです
     - Returns: SceneBackRequest 前の画面への遷移リクエストが成功したらSceneBackRequestはtrueを返します
     */
    public func onRelease(stage: UIViewController) -> Bool {
        _ = stage.navigationController?.popViewController(animated: true)
        return true
    }
    
}
