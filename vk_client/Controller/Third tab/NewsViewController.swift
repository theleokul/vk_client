//
//  NewsViewController.swift
//  vk_client
//
//  Created by Leonid Kulikov on 31/07/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController {

    var news = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Network
        DispatchQueue.global(qos: .userInteractive).async() {
            VKService.shared.getNewsFeed { (news, error) in
                if let news = news {
                    self.news = news
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    print(error?.localizedDescription ?? "" + "InternalGroupsTableViewController")
                }
            }
        }
        
        // Customization
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        let oneNews = news[index]
    
        if news[index].articleImageURLString == "" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextNewsCell", for: indexPath) as! TextNewsCell
            cell.setup(news: oneNews)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PicNewsCell", for: indexPath) as! PicNewsCell
            cell.setup(news: oneNews)
            return cell
        }

    }
        
        
        
        
        
        
        
//        // Configure the cell...
//        cell.iconImageView.image = UIImage(named: "ellie4")
//        cell.nameLabel.text = "Ellie"
//        cell.articleLabel.text = "Hello, this is my test article for app. I want to test there how text is truncated and how it looks in UI. I am very proud to be on the way of becoming true programmer. Peace!"
//        //cell.articleImageView.image = UIImage(named: "dawn")
//        cell.likesLabel.text = "154"
//        cell.commentsLabel.text = "27"
//        cell.repostsLabel.text = "14"
//        cell.viewsLabel.text = "1024"

    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


