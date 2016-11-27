//
//  Sample2AScene.swift
//  Example
//
//  Created by crexista on 2016/11/25.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation
import KabuKit

extension Sample2AViewController: ActionScene {
    
    enum Sample2Link: SceneLink {
        case A
        case B
    }
    
    typealias Stage = UIViewController
    typealias Context = Bool
    typealias Link = Sample2Link
    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        let action = Sample2AAction(nextButtonA: nextButtonA, nextButtonB: nextButtonB, prevButton: prevButton)
        actor.activate(action: action, transition: transition, context: context)
    }
    
    func onSceneTransitionRequest(link: Sample2Link, maker: Maker<UIViewController>, scenario: Scenario?) -> Request? {
        
        var request: Request?
        
        switch link {
        case .A:
            let File2A = ViewControllerXIBFile("Sample2AViewController", Bundle.main)
            request = maker.make(File2A, Sample2AViewController.self, true) { (stage, scene) in
                stage.navigationController?.pushViewController(scene, animated: true)
            }
            break;
        case .B:
            let File2B = ViewControllerXIBFile("Sample2BViewController", Bundle.main)
            request = maker.make(File2B, Sample2BViewController.self, true) { (stage, scene) in
                stage.navigationController?.pushViewController(scene, animated: true)
            }
        }

        return request
    }
    
    func onBackRequest(container: UIViewController) {
        _ = container.navigationController?.popViewController(animated: true)
    }
}