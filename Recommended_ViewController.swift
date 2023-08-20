//
//  Recommended_ViewController.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/11/01.
//

import UIKit
import Firebase
class Recommended_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var dataSet: [[String]] = []
    var myindustry: String! = ""
    var talkContentsCount: Int = 0

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        getfirebase()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.

    }

    func getfirebase() {
        let userID = Auth.auth().currentUser!.uid
        let docRef = Firestore.firestore().collection("users").document(userID).addSnapshotListener { (snapShot, error) in
        self.dataSet = []

            if error != nil {
                return
            }
    
            self.myindustry = (snapShot?.get("industry") as! String)
            print(self.myindustry!)
            
            let query = Firestore.firestore().collection("talkerPost").whereField("industry1", isEqualTo: self.myindustry!).getDocuments() { (querySnapshot, err) in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")

                        //ここにtableViewにどんどん値入れていく処理入れる

                        let data = document.data()
                        let title:String = data["talkTitle"] as! String
                        //let name = data[""]
                        let catchcopy:String = data["catchCopy"] as! String
                        let price:String = data["price"] as! String + "円"
                        let talktime:String = data["talkTime"] as! String

                        self.dataSet.append([title,catchcopy,price,talktime])
                        //print(name!)
                        print(self.dataSet)
                        print(self.dataSet[0][0])

                        self.tableView.reloadData()
                        //クエリによって出てきたデータの数だけ、tableViweが生成される仕組み
                    }
                }
             }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        let titleLabel = cell.viewWithTag(1) as! UILabel
        //print(self.dataSet[indexPath.row])

        titleLabel.text = dataSet[indexPath.row][0]
        let talkerLabel = cell.viewWithTag(2) as! UILabel
        talkerLabel.text = "b"
        
        let catchCopyLabel = cell.viewWithTag(3) as! UITextView
        catchCopyLabel.text = dataSet[indexPath.row][1]
        catchCopyLabel.isEditable = false
        //let image = cell.viewWithTag(4)　←プロフィールの画像
        let talktimeLabel = cell.viewWithTag(5) as! UILabel
        talktimeLabel.text = dataSet[indexPath.row][2]
        
        let priceLabel = cell.viewWithTag(6) as! UILabel
        priceLabel.text = dataSet[indexPath.row][3]
        
        return cell
    }

    

    func tableView(_ table: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
