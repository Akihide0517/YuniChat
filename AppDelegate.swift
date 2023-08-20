//
//  AppDelegate.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/02/26.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

var enemyimage = UIImage(named: "")
var myimage = ""
var enemyname = ""
var myname = ""
var mytruename = ""
var roomname = ""
var copyurl = ""
var search = ""
var whochat = 0
var nowload = 0
var nowview = 0
var isChat = 0
var sentmode = 0
var sender = ""
var testenemyname = ""

var yourtoken = ""
var yourDtoken = ""
var key = "key=AAAAGnAlDJw:APA91bE0p6PtR-wxFvSteYn70Q_rXjEmfEdi-tZs-1paxc0ujiewg1jrnWh6HoOLty-6topfou8KMZVengCX0vBgxlkxdOyj7U55Cq25ubogWm32AFhkevsHHeH7MSs7SN3nc1PVfpQy"

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var numberValue : int_fast8_t!
    var nameValue : String?
    weak var multitaskDelegate: MultitaskDelegate?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        //UNUserNotificationCenter.current().delegate = self
        // 初回起動時、プッシュ通知の許可ダイアログを表示させる
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { _, _ in }
        )
    
        application.registerForRemoteNotifications()

        // デバイストークンの登録
         registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        
        
        // Override point for customization after application launch.
        // プッシュ通知のペイロード（userInfo）をデータとして取得
        if let payload = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            let payloadData = payload.map { (key, value) in "\"\(key)\":\"\(value)\"" }.joined(separator: "\n")
            print("Received notification payload at launch: \(payloadData)")
            
            // 通知の内容を取得
            if let aps = payload["aps"] as? [String: Any],
               let alert = aps["alert"] as? [String: Any],
               let title = alert["title"] as? String,
               let body = alert["body"] as? String {
                // 通知のタイトルと本文を取得できる
                print("Received notification title at launch: \(title)")
                print("Received notification body at launch: \(body)")
                
                // 通知のタイトルをUserDefaultsに保存
                UserDefaults.standard.set(title, forKey: "notificationTitle")
                print("通知のタイトルを保存しました（アプリ起動時）：\(title)")
            }
        }
        
        return true
    }
    
    // デバイスのプッシュ通知登録
      func registerForPushNotifications() {
          UNUserNotificationCenter.current().delegate = self
          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (granted, error) in
              if let error = error {
                  print("Error: \(error)")
              } else {
                  DispatchQueue.main.async {
                      UIApplication.shared.registerForRemoteNotifications()
                  }
              }
          }
      }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("return!")
    }
    
    // プッシュ通知の登録が成功した場合に呼ばれるメソッド
     func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
         let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
         let token = tokenParts.joined()
         print("Device Token: \(token)")
     }
     
     // プッシュ通知の登録が失敗した場合に呼ばれるメソッド
     func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
         print("Failed to register for remote notifications: \(error.localizedDescription)")
     }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // 通知の内容を取得
        let content = response.notification.request.content
        print("バックグラウンドでプッシュ通知を受信！")
        print("Received notification content: \(content)")

        // 通知のuserInfoから送信者名を取得
        if let senderName = content.userInfo["senderName"] as? String {
            print("送信者名: \(senderName)")
        }

        // アラートスタイルの通知を表示するために、.alertオプションを指定
        completionHandler()
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 通知の内容を取得
        let content = notification.request.content
        print("フォアグラウンドでプッシュ通知を受信")
        multitaskDelegate?.didReturnFromMultitask()
        // 通知のuserInfoから送信者名を取得
        if let senderName = content.userInfo["senderName"] as? String {
            print("送信者名: \(senderName)")
        }

        // アラートスタイルの通知を表示するために、.alertオプションを指定
        if (isChat == 0) {
            completionHandler([.alert, .sound])
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        } else {
            print("chatroomにいるので表示しませんでした")
        }
    }
    
    // デバイストークンの登録
        func registerForRemoteNotifications() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (_, _) in
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    
    // デバイストークンの取得に成功した時に呼ばれる
       func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
           guard let token = fcmToken else {
               return
           }
           
           // デバイストークンをサーバーに送信して登録する処理を実装する
           // ここでサーバーサイドとの通信を行い、デバイストークンを保存するなどの処理を行います
           
           // 例えば、デバイストークンをログに表示する場合
           print("FCM Token: \(token)")
           yourtoken = token
       }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Print message ID.
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
        
        // プッシュ通知のペイロード（userInfo）をデータとして取得
        let payloadData = userInfo.map { (key, value) in "\"\(key)\":\"\(value)\"" }.joined(separator: "\n")
        print("Received notification payload: \(payloadData)")
        
        // 通知の内容を取得
        if let aps = userInfo["aps"] as? [String: Any],
           let alert = aps["alert"] as? [String: Any],
           let title = alert["title"] as? String,
           let body = alert["body"] as? String {
            // 通知のタイトルと本文を取得できる
            print("Received notification title: \(title)")
            print("Received notification body: \(body)")
            
            // 通知のタイトルをUserDefaultsに保存
            UserDefaults.standard.set(title, forKey: "notificationTitle")
            print("通知のタイトルを保存しました：\(title)")
        }
        
        // 通知を処理したことをコールバックで伝える
        completionHandler(.newData)
    }
}

extension AppDelegate: MessagingDelegate {
    
    private func showAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // 現在表示中の画面を取得
        if let viewController = window?.rootViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
}

