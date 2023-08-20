//
//  TimelineViewController.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/06/10.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class TimelineViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView! // 追加
    
    var userDefaults = UserDefaults.standard
    var postArray = [String]()
    var me = UserDefaults.standard.object(forKey: "ki-") as! String
    var database: Firestore! // 宣言
    var post = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Firestore.firestore() // 初期値代入
        tableView.delegate = self  // 追加
        tableView.dataSource = self // 追加
    }

    // 投稿追加画面に遷移するボタンを押したときの動作を記述。
    @IBAction func toAddViewController() {
        performSegue(withIdentifier: "Add", sender: me)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        database.collection("posts").getDocuments { (snapshot, error) in
            if error == nil, let snapshot = snapshot {
                self.postArray = [""]
                for document in snapshot.documents {
                    let data = document.data()
                    var post = Post(data: data)
                    self.postArray.append(contentsOf: self.post)
                }
                print(self.postArray)
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = self.postArray[indexPath.row]//.content
        return cell
    }
}
