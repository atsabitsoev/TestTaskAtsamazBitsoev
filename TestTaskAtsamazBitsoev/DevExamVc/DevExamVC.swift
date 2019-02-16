//
//  DevExamVC.swift
//  TestTaskAtsamazBitsoev
//
//  Created by Ацамаз on 16/02/2019.
//  Copyright © 2019 a.s.bitsoev. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class DevExamVC: UITableViewController {
    
    
    @IBOutlet weak var segControllSort: UISegmentedControl!
    
    var posts = Authorization.standard.posts
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
        updatePosts()
        setTimer()
        
    }

    
    // MARK: - Table view data source
    // КОЛИЧЕСТВО СЕКЦИЙ
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }

    // КОЛИЧЕСТВО ЯЧЕЕК В СЕКЦИИ
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
        
    }
    
    
    // ВЫСОТА ЯЧЕЙКИ
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    // ЯЧЕЙКА
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "devExamCell") as! DevExamCell
        
        cell.labTitle.text = posts[indexPath.row].title
        cell.labDescribtion.text = posts[indexPath.row].describtion
        
        let df = DateFormatter()
        df.dateFormat = "dd.MM.YYY, HH:mm:ss"
        let date = posts[indexPath.row].date
        let dateString = df.string(from: date)
        cell.labDate.text = dateString
        
        let url = posts[indexPath.row].imageURL
        
        Alamofire.request(url).responseImage { (response) in
            
            cell.mainImage.image = response.value
            cell.mainImage.layer.cornerRadius = cell.mainImage.bounds.height / 2
            cell.mainImage.layer.masksToBounds = true
            
        }
        
        return cell
        
    }
    
    
    // ДОБАВИТЬ НАБЛЮДАТЕЛИ
    func addObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(postsUpdated),
                                               name: NSNotification.Name(rawValue: "postsUpdated"),
                                               object: nil)
        
    }
    
    
    // ТАЙМЕР
    func setTimer() {
        
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { (timer) in
            self.updatePosts()
        }
        
    }
    
    
    // ОБНОВИТЬ ПОСТЫ
    func updatePosts() {
        
        Authorization.standard.getPosts()
        
    }
    
    
    // КОГДА ПОСТЫ ОБНОВЛЕНЫ
    @objc func postsUpdated() {
        
        posts = Authorization.standard.posts
        sortPosts()
        self.tableView.reloadData()
        
    }
    
    
    // ПЕРЕХОД К ЭКРАНУ ПОСТА
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPost" {
            
            let postVc = segue.destination as! PostVC
            let index = self.tableView.indexPathForSelectedRow!.row
            postVc.currentPost = posts[index]
            
        }
    }
    
    
    @IBAction func updateButTapped(_ sender: Any) {
        
        updatePosts()
        
    }
    
    
    
    @IBAction func sortStyleChanged(_ sender: UISegmentedControl) {
        
        sortPosts()
        
    }
    
    
    // СОРТИРОВКА ПОСТОВ
    func sortPosts() {
        
        if segControllSort.selectedSegmentIndex == 1 {
            
            posts.sort { (post1, post2) -> Bool in
                return post1.date > post2.date
            }
            
        } else {
            
            posts.sort { (post1, post2) -> Bool in
                
                return post1.sort < post2.sort
                
            }
            
        }
        
        self.tableView.reloadData()
        
    }
    

}




// КОНВЕРТИРОВАНИЕ ДАТЫ В СТРОКЕ
extension String {
    
    func convertDate() -> String {
        var string = ""
        
        for c in self {
            
            string.append(c)
            
            if c == "T" || c == "Z" {
                string.removeLast()
                string.append(" ")
            } else if c == "-" {
                string.removeLast()
                string.append(".")
            }
        }
        
        return string
        
    }
    
}
