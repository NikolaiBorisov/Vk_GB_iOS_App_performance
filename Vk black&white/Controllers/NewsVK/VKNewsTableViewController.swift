//
//  VKNewsTableViewController.swift
//  Vk black&white
//
//  Created by NIKOLAI BORISOV on 20.03.2021.
//

import UIKit

class VKNewsTableViewController: UITableViewController {
    
    var posts: [Post]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(NewsHeaderViewCell.nib, forCellReuseIdentifier: NewsHeaderViewCell.reuseIdentifier)
        self.tableView.register(NewsFooterViewCell.nib, forCellReuseIdentifier: NewsFooterViewCell.reuseIdentifier)
        
        let networkManager = NetworkManager()
        networkManager.loadNews() { posts in
            self.posts = posts
        }
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.posts?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "VKNews", for: indexPath)
        
        switch indexPath.row {
        case 0:
            guard
                let post = self.posts?[indexPath.section],
                let cell = self.tableView.dequeueReusableCell(withIdentifier: NewsHeaderViewCell.reuseIdentifier) as? NewsHeaderViewCell
            else { return NewsHeaderViewCell() }
            cell.configure(with: post)
            return cell
            
        case 1:
            return NewsHeaderViewCell()
        case 2:
            return NewsFooterViewCell()
        default:
            return NewsHeaderViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 145
        case 2:
            return 40
        default:
            return 100
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
