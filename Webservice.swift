//
//  Webservice.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/07/08.
//
import Foundation

class Webservice {

    func getArticles(with urlString:String,completion:@escaping ([Article]?) -> ()){
        if let url = URL(string: urlString) {

            let session = URLSession(configuration: .default)

            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)

                    completion(nil)
                }

                if let safeData = data {
                     print(response)
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(ArticleList.self, from: safeData)

                        completion(decodedData.articles)

                    } catch  {
                        print(String(describing: error))

                    }
                }
            }

            task.resume()
        }
    }
}
