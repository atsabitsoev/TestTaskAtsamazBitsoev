//
//  Post.swift
//  TestTaskAtsamazBitsoev
//
//  Created by Ацамаз on 16/02/2019.
//  Copyright © 2019 a.s.bitsoev. All rights reserved.
//

import Foundation

class Post {
    
    var title: String
    var describtion: String
    var imageURL: URL
    var date: Date
    var sort: Int
    
    init(title: String,
        describtion: String,
        imageURL: URL,
        date: Date,
        sort: Int) {
        
        self.title = title
        self.describtion = describtion
        self.imageURL = imageURL
        self.date = date
        self.sort = sort
        
    }
    
}
