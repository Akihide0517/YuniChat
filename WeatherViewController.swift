//
//  WeatherViewController.swift
//  newChat
//
//  Created by 吉田成秀 on 2023/03/24.
//

import UIKit
import Alamofire
import SwiftyJSON
import PKHUD

class WeatherViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet var tenkiImageView: UIImageView!
    @IBOutlet var max: UILabel!
    @IBOutlet var min: UILabel!
    @IBOutlet var taikan: UILabel!
    @IBOutlet var humidity: UILabel!
    @IBOutlet var wind: UILabel!
    @IBOutlet var backImageView : UIImageView!


    var descriptionWeather: String?
    var cityData : [String] = []
    var selectedCity : String!
    var longitude : Double!
    var latitude : Double!
    var text: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        //self.view.addBackground(name: "snow-mountain.jpg")


      //backImageView.layer.cornerRadius = backImageView.frame.size.width * 0.1
      //backImageView.clipsToBounds = true
        tenkiImageView.layer.cornerRadius = tenkiImageView.frame.size.width * 0.1
        tenkiImageView.clipsToBounds = true

        yoho()
    }

    func yoho() {
        let latitude = String(35.6894)
        let longitude = String(139.6917)
        text = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric&appid=de87faf8a2da1ed071a8ed0e7fe56048"


        let url = text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success:

                let json = JSON(response.data as Any)

                self.descriptionWeather = json["weather"][0]["main"].string!

                if self.descriptionWeather == "Clouds" {
                    self.tenkiImageView.image = UIImage(named: "kumori")
                }else if self.descriptionWeather == "Rain" {
                    self.tenkiImageView.image = UIImage(named: "ame")
                }else if self.descriptionWeather == "Snow"{
                    self.tenkiImageView.image = UIImage(named: "yuki")
                }else {
                    self.tenkiImageView.image = UIImage(named: "hare")
                }

                self.max.text = "最高気温：" + "\(Int(json["main"]["temp_max"].number!).description)℃"
                self.min.text = "最低気温：" + "\(Int(json["main"]["temp_min"].number!).description)℃"
                self.taikan.text = "体感：" + "\(Int(json["main"]["temp"].number!).description)℃"
                self.humidity.text = "湿度：" + "\(Int(json["main"]["humidity"].number!).description)%"
                self.wind.text = "風速：" + "\(Int(json["wind"]["speed"].number!).description)m/s"

            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func yesterday(_ sender: Any) {
        HUD.show(.progress)
        
        if(navigationItem.title == "明日の天気"){
            navigationItem.title = "東京の天気"
            yoho()
        }else{
            navigationItem.title = "明日の天気"
            
            let latitude = String(35.6894)
            let longitude = String(139.6917)
            text = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&units=metric&appid=de87faf8a2da1ed071a8ed0e7fe56048"
            
            let url = text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
                switch response.result {
                case .success:
                    
                    let json = JSON(response.data as Any)
                    print(json)
                    
                    self.descriptionWeather = String(json["list"][4]["weather"][0]["main"].string!)
                    
                    if self.descriptionWeather == "Clouds" {
                        self.tenkiImageView.image = UIImage(named: "kumori")
                    }else if self.descriptionWeather == "Rain" {
                        self.tenkiImageView.image = UIImage(named: "ame")
                    }else if self.descriptionWeather == "Snow"{
                        self.tenkiImageView.image = UIImage(named: "yuki")
                    }else {
                        self.tenkiImageView.image = UIImage(named: "hare")
                    }
                    
                    self.max.text = "最高気温：" + "\(Int(json["list"][4]["main"]["temp_max"].number!).description)℃"
                    self.min.text = "最低気温：" + "\(Int(json["list"][4]["main"]["temp_min"].number!).description)℃"
                    self.taikan.text = "体感：" + "\(Int(json["list"][4]["main"]["temp"].number!).description)℃"
                    self.humidity.text = "湿度：" + "\(Int(json["list"][4]["main"]["humidity"].number!).description)%"
                    self.wind.text = "風速：" + "\(Int(json["list"][4]["wind"]["speed"].number!).description)m/s"
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
        HUD.hide()
    }
}
