//
//  NewsListTableViewController.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/07/08.
//
//ニュースの起動が遅いのでHUDでロード画面を作っておくと良い
import Foundation
import UIKit
import SDWebImage

class NewsListTableViewViewController: UITableViewController{

    fileprivate var articles: [Article] = []
    var urlArticle = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup(){
        articles = []//キャッシュの削除
        
        let now = Date()
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: now)     // 2022
        let month = calendar.component(.month, from: now)   // 5
        let day = calendar.component(.day, from: now)       // 19
        var Month = ""
        var Day = ""
        var Day2 = ""
        
        if(month < 10){
            Month = "0" + String(month)
        }else{
            Month = String(month)
        }
        if(day < 10){
            Day = "0" + String(day-1)
            Day2 = "0" + String(day-2)
        }else{
            Day = String(day-1)
            Day2 = String(day-2)
        }
        
        //ここにAPIKeyを挿入する
        var urlString =  ""
        urlString =  "https://newsapi.org/v2/everything?q=apple&from=" + String(year) + "-" + Month + "-" + Day + "&to=" + String(year) + "-" + Month + "-" + Day + "&sortBy=popularity&apiKey=a6ea8d1ebbe94acca50b48974e5c1f67"
        
        print(urlString)
        let req_url = URL(string: urlString)
        let req = URLRequest(url: req_url!)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: req, completionHandler: {
                   (data, response, error) in
                   session.finishTasksAndInvalidate()
                   do{
                       let decode = JSONDecoder()
                       let json = try decode.decode(ArticleList.self, from: data!)
                   }catch{
                       print("error happened")
                   }
                })
        
        Webservice().getArticles(with: urlString,completion: { (articles) in
            guard let data = articles else{
                return
            }
            self.articles = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ArticleTableViewCell else {
            fatalError("ArticleTableViewCell not found")
        }
        cell.titleLabel.text = articles[indexPath.row].title
        cell.descriptionLabel.text = articles[indexPath.row].description
        cell.urlImageView.sd_setImage(with: URL(string: articles[indexPath.row].urlToImage), completed: nil)

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.urlArticle = articles[indexPath.row].url

        self.performSegue(withIdentifier: "toWeb", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWeb" {
            let detailVC = segue.destination as! DetailViewController
            detailVC.urlString = self.urlArticle
        }
    }
}
