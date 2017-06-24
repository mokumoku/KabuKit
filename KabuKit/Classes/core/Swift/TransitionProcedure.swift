//
//  Copyright © 2017 crexista
//

import Foundation

/**
 画面を切り替える手順を示したプロトコル

 */
protocol TransitionProcedure {
    
    typealias Rewind = () -> Void
   
    /**
     TransitionProcedureを実行するために必要なパラメータをセットする
     
     - Parameters:
       - at: どこの画面のTransitionProcedureか指定するため
       - stage: Transionを行うベースとなるメソッド
       - rewind: 前の画面に戻る為の処理
     */
    func setup<S>(at: Screen, on stage: S, with: SceneContainer, when rewind: Rewind?)
    
    func setup<S>(at: Screen, on stage: S, with: SceneContainer, when rewind: Rewind?, _ completion: @escaping () -> Void)
    
    /**
     TransitionProcedureを実行する
     
     - Parameters: 
       - request: aa
       - completion: Transtionの実行が完了した際に実行したい処理
       - setup: completionより前に呼ばれる
     */
    func start<T>(at request: Request<T>, _ completion: @escaping (Bool) -> Void) -> Void
    
    
    /**
     前の画面に戻る
     そのさい、事前に規定されたロジックが呼ばれる
     
     */
    func back(_ runRewindHandler: Bool, _ completion: @escaping (Bool) -> Void)
}