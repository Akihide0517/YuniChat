//
//  ChatListViewController.swift
//  ChatAppWithFirebase
//
//  Created by Uske on 2020/03/15.
//  Copyright © 2020 Uske. All rights reserved.
//

import UIKit
import Firebase
import Nuke
import UserNotifications

protocol MultitaskDelegate: AnyObject {
    func didReturnFromMultitask()
}

protocol SceneDelegateDelegate: AnyObject {
    func didReturnFromBackground()
}

extension UIView { 
    func innerShadow() {
        let path = UIBezierPath(rect: CGRect(x: -5.0, y: -5.0, width: self.bounds.size.width + 5.0, height: 5.0 ))
        let innerLayer = CALayer()
        innerLayer.frame = self.bounds
        innerLayer.masksToBounds = true
        innerLayer.shadowColor = UIColor.black.cgColor
        innerLayer.shadowOffset = CGSize(width: 2.5, height: 1.0)
        innerLayer.shadowOpacity = 0.6
        innerLayer.shadowPath = path.cgPath
        self.layer.addSublayer(innerLayer)
    }
}

class ChatListViewController: UIViewController, MultitaskDelegate, SceneDelegateDelegate{
    
    private let cellId = "cellId"
    private let logoutimage = UIImage(named: "navi")
    private let Newchatimage = UIImage(named: "new")
    private var chatroooms = [ChatRoom]()
    private var chatRoomListener: ListenerRegistration?
    private var infocounter = 0
    var userDefaults = UserDefaults.standard
    var alreadyload = false
    
    private var user: User? {
        didSet {
            //navigationItem.title = user?.username
            navigationItem.title = "ChatList"
        }
    }
    
    @IBOutlet weak var buttomtutorialview: UIView!
    @IBOutlet weak var tutorialview: UIView!
    @IBOutlet weak var UpBarView: UIView!
    @IBOutlet weak var ButtonBar: UIView!
    @IBOutlet weak var Openview: UIView!
    @IBOutlet weak var chatListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nowview = 0
        isChat = 0
        //myname = navigationItem.title!
        Openview.layer.cornerRadius = Openview.frame.height * 0.5
        UpBarView.innerShadow()

        // UserDefaultsに初回起動フラグが設定されているかを確認
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        
        if isFirstLaunch {
            tutorialview.isHidden = true
            buttomtutorialview.isHidden = true
            print("初回起動ではありません")
            
            //UserDefaults.standard.set(false, forKey: "isFirstLaunch")
        } else {
            tutorialview.isHidden = false
            buttomtutorialview.isHidden = false
            tappedLogoutButton()
            print("初回起動です")
        }
        
        if(UserDefaults.standard.object(forKey: "pass") == nil){
            tappedLogoutButton()
        }
        
        navigationController?.navigationBar.setBackgroundImage(.init(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layer.shadowRadius = 3.0
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 6)
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.7
        
        Openview.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        Openview.layer.shadowColor = UIColor.black.cgColor
        Openview.layer.shadowOpacity = 0.6
        Openview.layer.shadowRadius = 2.5
        
        ButtonBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.5)
        ButtonBar.layer.shadowColor = UIColor.black.cgColor
        ButtonBar.layer.shadowOpacity = 0.6
        ButtonBar.layer.shadowRadius = 3.5
        //self.view.sendSubviewToBack(n)
        // アプリ初期表示時にバッジ付与の許可を求める (初回はココでユーザに許可を得るダイアログが表示される)
        UNUserNotificationCenter.current().requestAuthorization(options: .badge) { (granted, eror) in
          if granted {
            print("許可 OK")
          }
          else {
            print("許可 NG")
          }
        }
        
        setupViews()
        confirmLoggedInUser()
        fetchChatroomsInfoFromFirestore()
        
        // info
        if UserDefaults.standard.object(forKey: "info") != nil {
        }else{
            userDefaults.set(infocounter, forKey: "info")
            performSegue(withIdentifier: "info", sender: nil)
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.multitaskDelegate = self
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.delegate = self
        alreadyload = false
    }
    
    func didReturnFromMultitask() {
        chatListTableView.estimatedRowHeight = 0
        chatListTableView.estimatedSectionHeaderHeight = 0
        fetchChatroomsInfoFromFirestore()
        print("UpDate1")
    }
    
    var backmode = 0
    func didReturnFromBackground() {
        if(alreadyload == true){
            backmode = 1
            
            fetchChatroomsInfoFromFirestore()
            print("UpDate2")
        }else{
            alreadyload = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLoginUserInfo()
        nowview = 0
        
        chatListTableView.estimatedRowHeight = 0
        chatListTableView.estimatedSectionHeaderHeight = 0
        fetchChatroomsInfoFromFirestore()
        
        isChat = 0
        print("UpDate3")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        chatListTableView.reloadData()
        
        // UserDefaultsに初回起動フラグが設定されているかを確認
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        
        if isFirstLaunch {
            tutorialview.isHidden = true
            buttomtutorialview.isHidden = true
            print("初回起動ではありません")
            
            //UserDefaults.standard.set(false, forKey: "isFirstLaunch")
        } else {
            tutorialview.isHidden = false
            buttomtutorialview.isHidden = false
            print("初回起動です")
        }
    }
    
    func fetchChatroomsInfoFromFirestore() {
        if(self.backmode == 1){
            //DispatchQueue.main.async { // メインスレッドで実行
                self.chatRoomListener?.remove()
                self.chatroooms.removeAll()
                self.chatListTableView.reloadData()
                self.backmode = 0
            //}
        }else{
            self.chatRoomListener?.remove()
            self.chatroooms.removeAll()
            self.chatListTableView.reloadData()
        }
        
        // チャットルームを作成日時で降順にソートして取得する
        chatRoomListener = Firestore.firestore().collection("chatRooms")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { (snapshots, err) in
                if let err = err {
                    print("ChatRooms情報の取得に失敗しました。\(err)")
                    return
                }

                snapshots?.documentChanges.forEach({ (documentChange) in
                    switch documentChange.type {
                    case .added:
                        self.handleAddedDocumentChange(documentChange: documentChange)
                    case .modified, .removed:
                        print("nothing to do")
                    }
                })

                self.chatListTableView.reloadData()
            }
    }
    
    private func handleAddedDocumentChange(documentChange: DocumentChange) {
        let dic = documentChange.document.data()
        let chatroom = ChatRoom(dic: dic)
        chatroom.documentId = documentChange.document.documentID
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let isConatin = chatroom.memebers.contains(uid)
        myname = uid
        
        if !isConatin { return }
        
        chatroom.memebers.forEach { (memberUid) in
            if memberUid != uid {
                Firestore.firestore().collection("users").document(memberUid).getDocument { (userSnapshot, err) in
                    if let err = err {
                        print("ユーザー情報の取得に失敗しました。\(err)")
                        return
                    }
                    
                    guard let dic = userSnapshot?.data() else { return }
                    let user = User(dic: dic)
                    user.uid = documentChange.document.documentID
                    chatroom.partnerUser = user
                    
                    guard let chatroomId = chatroom.documentId else { return }
                    let latestMessageId = chatroom.latestMessageId
                   
                    if latestMessageId == "" {
                        self.chatroooms.append(chatroom)
                        self.chatListTableView.reloadData()
                        return
                    }
                    
                    Firestore.firestore().collection("chatRooms").document(chatroomId).collection("messages").document(latestMessageId).getDocument { (messageSnapshot, err) in
                        if let err = err {
                            print("最新情報の取得に失敗しました。\(err)")
                            return
                        }
                        
                        guard let dic = messageSnapshot?.data() else { return }
                        let message = Message(dic: dic)
                        chatroom.latestMessage = message
                        
                        self.chatroooms.append(chatroom)
                        self.chatListTableView.reloadData()
                    }
                }
            }
        }
    }
    
    private func setupViews() {
        chatListTableView.tableFooterView = UIView()
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        
        navigationController?.navigationBar.barTintColor = .rgb(red: 211, green: 182, blue: 140)
        navigationItem.title = "Loading..."
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let rigntBarButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(tappedNavRightBarButton))
        //let logoutBarButton = UIBarButtonItem(image: UIImage(systemName: ""), style: .plain, target: self, action: #selector(tappedLogoutButton))
        navigationItem.rightBarButtonItem = rigntBarButton
        navigationItem.rightBarButtonItem?.tintColor = .white
        //navigationItem.leftBarButtonItem = logoutBarButton
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    private func tappedLogoutButton() {
        do {
            try Auth.auth().signOut()
            pushLoginViewController()
        } catch {
            print("ログアウトに失敗しました。 \(error)")
        }
    }
    
    private func confirmLoggedInUser() {
        if Auth.auth().currentUser?.uid == nil {
            pushLoginViewController()
        }
    }
    
    private func pushLoginViewController() {
        let storyboar = UIStoryboard(name: "SignUp", bundle: nil)
        let signUpViewController = storyboar.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        let nav = UINavigationController(rootViewController: signUpViewController)//MARK: here!
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc private func tappedNavRightBarButton() {
        let storyboard = UIStoryboard.init(name: "UserList", bundle: nil)
        let userListViewControlelr = storyboard.instantiateViewController(withIdentifier: "UserListViewController")
        let nav = UINavigationController(rootViewController: userListViewControlelr)
        self.present(nav, animated: true, completion: nil)
    }
    
    private func fetchLoginUserInfo() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("ユーザー情報の取得に失敗しました。\(err)")
                return
            }
            
            guard let snapshot = snapshot, let dic = snapshot.data() else { return }
            let user = User(dic: dic)
            self.user = user
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //chatroooms = Array(Set(chatroooms))
        return chatroooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatListTableViewCell
        cell.chatroom = chatroooms[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped table view")
        let storyboard = UIStoryboard.init(name: "ChatRoom", bundle: nil)
        let chatRoomViewController = storyboard.instantiateViewController(withIdentifier: "ChatRoomViewController") as! ChatRoomViewController
        chatRoomViewController.user = user
        chatRoomViewController.chatroom = chatroooms[indexPath.row]
        navigationController?.pushViewController(chatRoomViewController, animated: true)
        
    }
    
}

class ChatListTableViewCell: UITableViewCell {
    
    var globalVarA = ""
    var globalVarB = ""
    var globalValueA = ""
    
    /*テキストに干渉するならばここのメソッドを利用します*/
    //未読管理をRTDではできませんでしたが、firestoreではできました。やはり応答速度に問題があったようです。
    
    var chatroom: ChatRoom? {
        didSet {
            if let chatroom = chatroom {
                self.CheckPointer.isHidden = true
                partnerLabel.text = chatroom.partnerUser?.username
                guard let url = URL(string: chatroom.partnerUser?.profileImageUrl ?? "") else { return }

                Ex()
                Ex.staticValue3 = chatroom.partnerUser!.profileImageUrl
                
                Nuke.loadImage(with: url, into: userImageView)
                dateLabel.text = dateFormatterForDateLabel(date: chatroom.latestMessage?.createdAt.dateValue() ?? Date())
                latestMessageLabel.text = chatroom.latestMessage?.message
                
                self.partnerLabel.text = chatroom.partnerUser?.username
                self.latestMessageLabel.text = chatroom.latestMessage?.message
                self.dateLabel.text = dateFormatterForDateLabel(date: chatroom.latestMessage?.createdAt.dateValue() ?? Date())
                
                if let partnerLabelText = partnerLabel.text,
                   let message = UserDefaults.standard.string(forKey: "\(partnerLabelText)message") {
                    print(message + "here!!")
                    
                    if(message != latestMessageLabel.text){
                        CheckPointer.isHidden = false
                    }else{
                        CheckPointer.isHidden = true
                    }
                    
                } else {
                    print("Message not found in UserDefaults or partnerLabel text is nil")
                    UserDefaults.standard.set("", forKey: "\(partnerLabel.text)message")
                    CheckPointer.isHidden = true
                }
            }
        }
    }
    
    @IBOutlet weak var partnerLabel: UILabel!
    @IBOutlet weak var latestMessageLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var CheckPointer: UIView!
    
    @IBAction func imagebutton(_ sender: Any) {
        print("tap!")
        enemyname = partnerLabel.text!
        enemyimage = userImageView.image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = 30
        CheckPointer.layer.cornerRadius = 8
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        testenemyname = partnerLabel.text!
        print(testenemyname)
        super.setSelected(selected, animated: animated)
    }
    
    private func dateFormatterForDateLabel(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }

    private var latestMessageLabelObserver: NSKeyValueObservation?
}
