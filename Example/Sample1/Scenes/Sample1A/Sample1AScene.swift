//
//  Sample1AScene.swift
//  Example
//
//  Created by crexista on 2016/11/24.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation
import KabuKit

extension Sample1AViewController: ActionScene {
    
    enum Sample1Link : SceneLink {
        case A
        case B
    }
    
    typealias Stage = UIViewController
    typealias Context = Bool
    typealias Link = Sample1Link
    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        prevButton.isEnabled = context!
        let action = Sample1AAction(label: label, buttonA: nextButtonA, buttonB: nextButtonB, prevButton: prevButton)
        actor.activate(action: action, transition: self.transition, context: self.context)
    }
    
    func onSceneTransitionRequest(link: Sample1Link, maker: Maker<UIViewController>, scenario: Scenario?) -> Request? {
        
        switch link {
        case .A:
            let xib = ViewControllerXIBFile("Sample1AViewController", Bundle.main)
            let vc = maker.make(xib, Sample1AViewController.self, true) { (stage, scene) in
                stage.navigationController?.pushViewController(scene, animated: true)
            }
            return vc
        case .B:
            let xib = ViewControllerXIBFile("Sample1BViewController", Bundle.main)
            let vc = maker.make(xib, Sample1BViewController.self, nil) { (stage, scene) in
                stage.navigationController?.pushViewController(scene, animated: true)
            }
            return vc
        }
    }
    
    func onBackRequest(container: UIViewController) {
        _ = container.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if (self.navigationController == nil) {
            //transition.back()
        }
    }

}