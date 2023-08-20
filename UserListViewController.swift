//
//  UserListViewController.swift
//  ChatAppWithFirebase
//
//  Created by Uske on 2020/03/28.
//  Copyright © 2020 Uske. All rights reserved.
//

import UIKit
import Firebase
import Nuke

class UserListViewController: UIViewController, UISearchBarDelegate {
    
    private let cellId = "cellId"
    private var users = [User]()
    private var selectedUser: User?
    
    @IBOutlet weak var userListTableView: UITableView!
    @IBOutlet weak var startChatButton: UIButton!
    @IBOutlet weak var UISearchBar: UISearchBar!
    @IBOutlet weak var SearchView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Search"
        self.navigationController?.navigationBar.titleTextAttributes = [
            // 文字の色
                .foregroundColor: UIColor.white
            ]
        
        //addBottomBorder(to: SearchView, color: UIColor.lightGray, height: 0.5)
        userListTableView.tableFooterView = UIView()
        userListTableView.delegate = self
        userListTableView.dataSource = self
        UISearchBar.delegate = self
        startChatButton.layer.cornerRadius = 15
        startChatButton.isEnabled = false
        startChatButton.addTarget(self, action: #selector(tappedStartChatButton), for: .touchUpInside)
        
        navigationController?.navigationBar.barTintColor = .rgb(red: 211, green: 182, blue: 140)
        fetchUserInfoFromFirestore()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func addBottomBorder(to view: UIView, color: UIColor, height: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: view.frame.size.height - height, width: view.frame.size.width, height: height)
        view.layer.addSublayer(border)
        
        setupSearchBar()
    }
    
    @objc func tappedStartChatButton() {
        print("tappedStartChatButton")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let partnerUid = self.selectedUser?.uid else { return }
        let memebers = [uid, partnerUid]
        
        let docData = [
            "memebers": memebers,
            "latestMessageId": "",
            "createdAt": Timestamp()
            ] as [String : Any]
        
        Firestore.firestore().collection("chatRooms").addDocument(data: docData) { (err) in
            if let err = err {
                print("ChatRoom情報の保存に失敗しました。\(err)")
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            print("ChatRoom情報の保存に成功しました。")
        }
    }
    
    private var useR:[String] = [""]
    private func fetchUserInfoFromFirestore() {
        //var useR:[String] = [""]
        useR = []
        
        Firestore.firestore().collection("users").getDocuments { (snapshots, err) in
            if let err = err {
                print("user情報の取得に失敗しました。\(err)")
                return
            }
            
            snapshots?.documents.forEach({ (snapshot) in
                let dic = snapshot.data()
                let user = User.init(dic: dic)
                user.uid = snapshot.documentID
                print("user")
                print(user.username)//相手の名前
                self.useR += [user.username]
                print(self.useR)
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                if uid == snapshot.documentID {
                    return
                }
                
                self.users.append(user)
                self.userListTableView.reloadData()
            })
        }
    }
    
    let myRefreshControl = UIRefreshControl()
    var currentItems:[String] = [""]
    func setupSearchBar(){
        if let searchBar = UISearchBar {
            searchBar.delegate = self
        } else {
            // もしUISearchBarがnilの場合はエラーメッセージを表示して対応する必要があります
            print("UISearchBarがnilです")
        }
    }
    
    //  検索バーに入力があったら呼ばれる
    private var searchResults = [User]()
    private var isSearching: Bool {
        return !UISearchBar.text!.isEmpty
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults.removeAll()
        
        if !searchText.isEmpty {
            let filteredUsers = users.filter { $0.username.lowercased().contains(searchText.lowercased()) }
            searchResults.append(contentsOf: filteredUsers)
        }
        
        userListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UISearchBar.text! = "" // キャンセルボタンを押したら検索テキストをリセット
        userListTableView.reloadData()
    }
}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? searchResults.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserListTableViewCell
        let user = isSearching ? searchResults[indexPath.row] : nil
        cell.user = user
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        startChatButton.isEnabled = true
        let user = isSearching ? searchResults[indexPath.row] : nil
        self.selectedUser = user
    }
}

class UserListTableViewCell: UITableViewCell {
    
    var user: User? {
        didSet {
                usernameLabel.text = user!.username
                if let url = URL(string: user?.profileImageUrl ?? "") {
                    Nuke.loadImage(with: url, into: userImageView)
                }
        }
    }
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    //プロトコルからは呼び出せないので実装時は別の方法を使ってください
    @IBAction func enemyimages(_ sender: Any) {
        enemyimage = userImageView.image
        enemyname = usernameLabel.text!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = 32.5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
