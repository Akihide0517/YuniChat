//
//  ClubViewController.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/06/24.
//
import Foundation
import UIKit
import Firebase

class ClubViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBAction func modoru(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    @IBAction func changebutton(_ sender: Any) {
        let alert = UIAlertController(title: "Teamの削除", message: "削除するとすべての登録がこの端末から消えます", preferredStyle: .actionSheet)//←ここを変更
        let ok = UIAlertAction(title: "削除", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
            self.userDefaults.removeObject(forKey: "room")
            self.TableView2.reloadData()
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (acrion) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var hideview: UIView!
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
            TableView2.reloadData()
        }
        nowtext = 0
    }
    
    @IBAction func makebutton(_ sender: Any) {
        join()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Team"
        isChat = 0
        print("UpDate")
    }
    
    @IBAction func Make(_ sender: UIButton) {
        modeing = 1
    }
    
    @IBOutlet weak var  MakeButoon: UIView!
    @IBOutlet weak var ButtonBar2: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Team"
        self.navigationItem.hidesBackButton = true
        hideview.isHidden = false
        //TableView.layer.cornerRadius = 10
        //本体の配列の初期化
        //userDefaults.removeObject(forKey: "room")
        
        isChat = 0
        
        MakeButoon.innerShadow()
        
        ButtonBar2.layer.shadowOffset = CGSize(width: 0.0, height: 2.5)
        ButtonBar2.layer.shadowColor = UIColor.black.cgColor
        ButtonBar2.layer.shadowOpacity = 0.6
        ButtonBar2.layer.shadowRadius = 3.5
        
        if UserDefaults.standard.object(forKey: "myname") != nil {
            // キーの中身が空でなければ変数に入れる
            mytruename = UserDefaults.standard.object(forKey: "myname") as! String
        }
        if UserDefaults.standard.object(forKey: "room") != nil {
            getRoom = userDefaults.array(forKey: "room") as! [String]
            fruits = getRoom
            TableView2.reloadData()
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkEmptyTextField()
    }
    
    func checkEmptyTextField() {
        if teamlabel.text?.isEmpty ?? true {
            hideview.isHidden = false
        } else {
            hideview.isHidden = true
        }
    }
    
    @objc func didTapDoneButton() {
        teamlabel.resignFirstResponder()
        checkEmptyTextField()
    }

   @objc func keyboardWillShow(_ notification: NSNotification){
       if let userInfo = notification.userInfo, let keyboardFrameInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           //inputViewBottomMargin.constant = keyboardFrameInfo.cgRectValue.height
       }
   }

   @objc func keyboardWillHide(_ notification: NSNotification){
   }
    
    @IBOutlet weak var TableView2: UITableView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fruits = Array(Set(fruits))
        print(fruits)
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
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SampleCell2", for: indexPath)
        cell.textLabel!.text = fruits[indexPath.row]
        
        let text = String(fruits[indexPath.row])
        let size = CGSize(width: 60, height: 60) // 画像サイズを適切に調整してください
        let backgroundColor = gradientColor(startColor: .rgb(red: 211, green: 182, blue: 140), endColor: gradientTextColor(for: text, size: size), size: size)
        let textColor = UIColor.white
        let font = UIFont.boldSystemFont(ofSize: 20)
        
        if let profileImage = generateProfileImage(withText: text, size: size, backgroundColor: backgroundColor, textColor: textColor, font: font) {
            // 生成した画像をセルのimageViewに設定
            cell.imageView?.image = circularImage(image: profileImage)
            // グラデーションを追加する
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = cell.bounds
            gradientLayer.colors = [UIColor.blue.cgColor, UIColor.green.cgColor] // グラデーションの色を設定
            cell.layer.insertSublayer(gradientLayer, at: 0) // グラデーションレイヤーをセルの最背面に配置
        }
        
        return cell
    }
    
    // テキストを基にしたグラデーション背景色を作成する関数
    func gradientTextColor(for text: String, size: CGSize) -> UIColor {
        let red = CGFloat(abs(text.hashValue) / 256 % 256) / 255.0
        let green = CGFloat(abs(text.hashValue % 256)) / 255.0
        let blue = CGFloat(abs(text.hashValue / 256 / 256 % 256)) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    // グラデーション背景色を作成する関数
    func gradientColor(startColor: UIColor, endColor: UIColor, size: CGSize) -> UIColor {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image!)
    }
    
    // プロフィール用の正方形画像を円形にクリップする関数
    func circularImage(image: UIImage) -> UIImage {
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = image.size.width / 2
        imageView.layer.masksToBounds = true

        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()!
        imageView.layer.render(in: context)
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return resultImage
    }
    
    func generateProfileImage(withText text: String, size: CGSize, backgroundColor: UIColor, textColor: UIColor, font: UIFont) -> UIImage? {
        // ビットマップコンテキストを作成
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        // 正方形の背景を描画
        backgroundColor.setFill()
        let squarePath = UIBezierPath(rect: CGRect(origin: .zero, size: size))
        squarePath.fill()
        
        // テキストを描画
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        let textRect = CGRect(x: 0, y: size.height / 2 - font.lineHeight / 2, width: size.width, height: font.lineHeight)
        text.draw(in: textRect, withAttributes: attributes)
        
        // 描画した画像を取得
        let profileImage = UIGraphicsGetImageFromCurrentImageContext()
        return profileImage
    }
    
    // 独創的な図形を描画する関数
    func drawCustomShape(size: CGSize) -> UIColor {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!

        // 円形のグラデーションを描画
        let colors: [CGColor] = [UIColor.red.cgColor, UIColor.blue.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let radius = min(size.width, size.height) / 2
        context.drawRadialGradient(gradient!, startCenter: center, startRadius: 0, endCenter: center, endRadius: radius, options: [])
        
        // 独創的な図形を描画（ここでは、線を描画しています）
        context.move(to: CGPoint(x: 0, y: 0))
        context.addLine(to: CGPoint(x: size.width, y: size.height))
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(5.0)
        context.strokePath()

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return UIColor(patternImage: image!)
    }

}
