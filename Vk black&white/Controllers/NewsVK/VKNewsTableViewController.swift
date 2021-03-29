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
        
        let headerNib = UINib(nibName: "NewsHeaderViewCell", bundle: nil)
        self.tableView.register(headerNib, forCellReuseIdentifier: "HeaderCell")
        
        let footerNib = UINib(nibName: "NewsFooterViewCell", bundle: nil)
        self.tableView.register(footerNib, forCellReuseIdentifier: "FooterCell")
        
        let postNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        self.tableView.register(postNib, forCellReuseIdentifier: "PostCell")
        
        let photoNib = UINib(nibName: "PhotoTableViewCell", bundle: nil)
        self.tableView.register(photoNib, forCellReuseIdentifier: "PhotoCell")
        
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
        
        guard let post = self.posts?[indexPath.section] else { return PostTableViewCell() }
        
        switch indexPath.row {
        case 0:
            guard
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as? NewsHeaderViewCell
            else { return NewsHeaderViewCell() }
            cell.configure(with: post)
            return cell
            
        case 1:
            guard
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostTableViewCell
            else { return PostTableViewCell() }
            cell.configure(with: post)
            return cell
            
        case 2:
            guard
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "FooterCell") as? NewsFooterViewCell
            else { return NewsFooterViewCell() }
            cell.configure(with: post)
            return cell
            
        default:
            return NewsHeaderViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 2:
            return 60
            
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 2:
            return 60
            
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
