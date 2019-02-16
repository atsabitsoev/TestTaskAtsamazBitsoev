//
//  Authorization.swift
//  TestTaskAtsamazBitsoev
//
//  Created by Ацамаз on 16/02/2019.
//  Copyright © 2019 a.s.bitsoev. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Authorization {
    
    // SINGLETON
    static let standard = Authorization()
    private init() {}
    
    
    // ТЕКУЩИЙ МАССИВ ПОСТОВ
    var posts: [Post] = [] {
        didSet {
            
            NotificationCenter.default.post(name: NSNotification.Name("postsUpdated"), object: nil)
        }
    }
    
    
    // АВТОРИЗАЦИЯ ПОЛЬЗОВАТЕЛЯ
    func authorizeUser(phone: String, password: String) {
        
        let url = URL(string: "http://dev-exam.l-tech.ru/api/v1/auth")!
        let params: [String: Any] = ["phone": phone,
                      "password": password]
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers)
            .responseJSON { (response) in
            
                switch response.result {
                    
                case .success:
                    
                    let succeed = JSON(response.result.value!)["success"].intValue == 1
                    
                    if succeed {
                        
                        NotificationCenter.default.post(name: NSNotification.Name("authSucceed"), object: nil)
                        
                    } else {
                        
                        NotificationCenter.default.post(name: NSNotification.Name("authFailed"), object: nil)
                        
                        
                    }
                    
                case .failure:
                    
                    NotificationCenter.default.post(name: NSNotification.Name("authFailed"), object: nil)

                }
                
            }
        
    }
    
    
    // ПОЛУЧИТЬ ПОСТЫ
    func getPosts() {
        
        let url = URL(string: "http://dev-exam.l-tech.ru/api/v1/posts")!
        
        Alamofire.request(url, method: .get, parameters: [:], encoding: URLEncoding.default, headers: [:])
            .responseJSON { (response) in
                
                switch response.result {
                    
                case .success:
                    
                    print(response.result.value!)
                    
                    var currentPosts: [Post] = []
                    let jsonArr = JSON(response.result.value!).array
                    for post in jsonArr! {
                        
                        let title = post["title"].stringValue
                        let describtion = post["text"].stringValue
                        let imageURL = URL(string: "http://dev-exam.l-tech.ru" + post["image"].stringValue)!
                        let sort = post["sort"].intValue
                        
                        let df = DateFormatter()
                        df.dateFormat = "YYYY.MM.dd HH:mm:ss "
                        df.timeZone = TimeZone.current
                        let dateString = post["date"].stringValue
                        let date = df.date(from: dateString.convertDate())
                        
                        let currentPost = Post(title: title,
                                               describtion: describtion,
                                               imageURL: imageURL,
                                               date: date!,
                                               sort: sort)
                        currentPosts.append(currentPost)
                        
                    }
                    
                    self.posts = currentPosts
                    
                case .failure:
                    
                    print(response.result.error!)
                    
                }
                
                
                
            }
        
    }
    
    
}
