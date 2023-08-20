//
//  meetingcontroller.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/11/24.
//
import UIKit
import Firebase

class meetingcontroller: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var teamlabel: UITextField!
    var databaseRef: DatabaseReference!
    var userDefaults = UserDefaults.standard
    var fruits:[String] = []
    var getRoom:[String] = [""]
    var nowtext = 0
    
    func join(){
        if(nowtext == 0){
            roomname = teamlabel.text!
        }
        
        // userDefaultsに保存された値の取得
        if UserDefaults.standard.object(forKey: "room") != nil {
            getRoom = userDefaults.array(forKey: "room") as! [String]
            print(getRoom)
            let maxget = [roomname] + getRoom
            userDefaults.set(maxget, forKey: "room")
        }else{
            let maxget = [roomname]
            userDefaults.set(maxget, forKey: "room")
        }
        
        if UserDefaults.standard.object(forKey: "room") != nil {
            getRoom = userDefaults.array(forKey: "room") as! [String]
            fruits = getRoom
            TableView.reloadData()
        }
        nowtext = 0
    }
    
    @IBAction func makebutton(_ sender: Any) {
        join()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.layer.cornerRadius = 10
        //本体の配列の初期化
        //userDefaults.removeObject(forKey: "room")
        
        if UserDefaults.standard.object(forKey: "myname") != nil {
            // キーの中身が空でなければ変数に入れる
            mytruename = UserDefaults.standard.object(forKey: "myname") as! String
        }
        if UserDefaults.standard.object(forKey: "room") != nil {
            getRoom = userDefaults.array(forKey: "room") as! [String]
            fruits = getRoom
            TableView.reloadData()
        }
        
        let toolbar = UIToolbar()
        //完了ボタンを右寄せにする為に、左側を埋めるスペース作成
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                    target: nil,
                                    action: nil)
        //完了ボタンを作成
        let done = UIBarButtonItem(title: "完了",
                                   style: .done,
                                   target: self,
                                   action: #selector(didTapDoneButton))
        //toolbarのitemsに作成したスペースと完了ボタンを入れる。実際にも左から順に表示されます。
        toolbar.items = [space, done]
        toolbar.sizeToFit()

        //作成したtoolbarをtextFieldのinputAccessoryViewに入れる
        teamlabel.inputAccessoryView = toolbar
    }
    
    @objc func didTapDoneButton() {
        teamlabel.resignFirstResponder()
    }

   @objc func keyboardWillShow(_ notification: NSNotification){
       if let userInfo = notification.userInfo, let keyboardFrameInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           //inputViewBottomMargin.constant = keyboardFrameInfo.cgRectValue.height
       }
   }

   @objc func keyboardWillHide(_ notification: NSNotification){
       //inputViewBottomMargin.constant = 0
   }
    
    @IBOutlet weak var TableView: UITableView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fruits = Array(Set(fruits))
        return fruits.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        roomname = String(fruits[indexPath.row])
        nowtext = 1
        print(roomname)
        
        join()
        performSegue(withIdentifier: "teamroom", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SampleCell", for: indexPath)
        cell.textLabel!.text = "　　　  " + fruits[indexPath.row]
        
        return cell
    }
}
