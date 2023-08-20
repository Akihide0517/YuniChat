//
//  menucontroller2.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/12/12.
//

import Foundation
import UIKit

class menucontroller2: UIViewController {
    
    // ボールの速度と方向を表す変数
    var ballSpeedX: CGFloat = 4.0
    var ballSpeedY: CGFloat = -4.0
    
    // パドルの速度を表す変数
    var paddleSpeed: CGFloat = 10.0
    
    // ブロックの行数と列数を表す変数
    let rowCount = 5
    let colCount = 5
    
    // ブロックのサイズを表す変数
    let blockWidth: CGFloat = 60.0
    let blockHeight: CGFloat = 20.0
    
    // パドルとボールを表す変数
    var paddleView: UIView!
    var ballView: UIView!
    
    // ブロックを保存する配列
    var blocks: [UIView] = []
    
    var gameTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // パドルを作成
        paddleView = UIView(frame: CGRect(x: view.bounds.midX - 50, y: view.bounds.maxY - 80, width: 100, height: 10))
        paddleView.backgroundColor = UIColor.blue
        view.addSubview(paddleView)
        
        // ボールを作成
        ballView = UIView(frame: CGRect(x: view.bounds.midX - 15, y: view.bounds.midY - 15, width: 30, height: 30))
        ballView.backgroundColor = UIColor.red
        ballView.layer.cornerRadius = 15
        view.addSubview(ballView)
        
        // ブロックを作成
        for row in 0..<rowCount {
            for col in 0..<colCount {
                let blockView = UIView(frame: CGRect(x: CGFloat(col) * blockWidth, y: 100 + CGFloat(row) * blockHeight, width: blockWidth, height: blockHeight))
                blockView.backgroundColor = UIColor.green
                view.addSubview(blockView)
                blocks.append(blockView)
            }
        }
        
        // タイマーを起動してゲームループを開始
        gameTimer = Timer(timeInterval: 0.03, target: self, selector: #selector(gameLoop), userInfo: nil, repeats: true)
        RunLoop.current.add(gameTimer!, forMode: .common)
        
        // パドルをドラッグで操作するためのジェスチャーを追加
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        paddleView.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began || gesture.state == .changed {
            let translation = gesture.translation(in: view)
            var newX = paddleView.center.x + translation.x

            // パドルが画面外に出ないように制約を設定
            let halfPaddleWidth = paddleView.frame.width / 2
            newX = max(halfPaddleWidth, newX)
            newX = min(view.bounds.maxX - halfPaddleWidth, newX)

            paddleView.center.x = newX
            gesture.setTranslation(.zero, in: view)
        }
    }
    
    @objc func gameLoop() {
        // ボールの移動
        ballView.center.x += ballSpeedX
        ballView.center.y += ballSpeedY
        
        // ボールが壁に当たった場合の処理
        if ballView.frame.minX <= 0 || ballView.frame.maxX >= view.bounds.maxX {
            ballSpeedX *= -1
        }
        if ballView.frame.minY <= 0 {
            ballSpeedY *= -1
        }
        
        // パドルとボールの衝突判定
        if ballView.frame.intersects(paddleView.frame) {
            ballSpeedY = abs(ballSpeedY) * -1
        }
        
        // ブロックとボールの衝突判定
        for block in blocks {
            if block.frame.intersects(ballView.frame) {
                block.removeFromSuperview()
                blocks.removeAll { $0 == block }
                ballSpeedY *= -1
            }
        }
        
        // ボールが画面外に出た場合の処理
        if ballView.frame.minY > view.bounds.maxY {
            gameOver()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // パドルの位置を指に追従させる
        if let touch = touches.first {
            let touchX = touch.location(in: view).x
            paddleView.center.x = touchX
        }
    }
    
    func gameOver() {
        // ゲームオーバー処理
        let alert = UIAlertController(title: "Game Over", message: "You lost!", preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart", style: .default) { [weak self] (_) in
            self?.restartGame()
        }
        alert.addAction(restartAction)
        present(alert, animated: true, completion: nil)
    }
    
    func restartGame() {
        // ゲームをリスタートする処理
        ballView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        ballSpeedX = 4.0
        ballSpeedY = -4.0
        for block in blocks {
            block.removeFromSuperview()
        }
        blocks.removeAll()
        for row in 0..<rowCount {
            for col in 0..<colCount {
                let blockView = UIView(frame: CGRect(x: CGFloat(col) * blockWidth, y: 100 + CGFloat(row) * blockHeight, width: blockWidth, height: blockHeight))
                blockView.backgroundColor = UIColor.green
                view.addSubview(blockView)
                blocks.append(blockView)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // モーダルビューが閉じる直前にタイマーを停止
        gameTimer?.invalidate()
        gameTimer = nil
    }
}
