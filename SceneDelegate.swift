//
//  SceneDelegate.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/02/26.
//

import UIKit
var backgroundmode = 0

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    weak var delegate: SceneDelegateDelegate?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene as! UIWindowScene)
        self.window = window
        window.makeKeyAndVisible()
        
        let storyboard = UIStoryboard(name: "ChatList", bundle: nil)
        let chatListViewController = storyboard.instantiateViewController(identifier: "ChatListViewController")
        let nav = UINavigationController(rootViewController: chatListViewController)
        
        window.rootViewController = nav
        
        guard let _ = (scene as? UIWindowScene) else { return }
        guard let _ = (scene as? UIWindowScene) else { return }
        
    }
    
    // バックグラウンド -> フォアグラウンド、で実行
    internal func sceneDidBecomeActive(_ scene: UIScene) {
        if(nowview == 0 && backgroundmode == 1){
            print("戻りました!")
            nowview = 1
            backgroundmode = 0
            self.delegate?.didReturnFromBackground()
        }
        
        UNUserNotificationCenter.current().getDeliveredNotifications { (notification) in
            if notification.isEmpty {
                // 受信してない
            } else {
                // 受信した
                print("受信しました!")
            }
        }
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        print("sceneWillEnterForeground\(nowview)\(backgroundmode)")
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        if(nowview == 1){
            print("sceneDidEnterBackground")
            nowview = 0
            backgroundmode = 1
        }
        
        UNUserNotificationCenter.current().getDeliveredNotifications { (notification) in
            if notification.isEmpty {
                // 受信してない
            } else {
                // 受信した
                print("受信しました")
            }
        }
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        if(backgroundmode == 0){
            print("sceneDidEnterBackground")
            nowview = 0
            backgroundmode = 1
        }
        
        UNUserNotificationCenter.current().getDeliveredNotifications { (notification) in
            if notification.isEmpty {
                // 受信してない
            } else {
                // 受信した
                print("受信しました")
            }
        }
        print("sceneWillResignActive\(nowview)\(backgroundmode)")
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        print("sceneDidDisconnect")
    }

}

