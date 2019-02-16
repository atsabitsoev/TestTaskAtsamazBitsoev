//
//  PostVC.swift
//  TestTaskAtsamazBitsoev
//
//  Created by Ацамаз on 16/02/2019.
//  Copyright © 2019 a.s.bitsoev. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class PostVC: UIViewController {
    
    
    var currentPost: Post!
    
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var labDescribtion: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labTitle.text = currentPost.title
        labDescribtion.text = currentPost.describtion
        
        let url = currentPost.imageURL
        Alamofire.request(url).response { (response) in
            
            self.mainImage.image = UIImage(data: response.data!)
            
        }
        
        mainImage.layer.cornerRadius = (UIScreen.main.bounds.width - 134) / 2
        mainImage.layer.masksToBounds = true
        
    }
    

}
