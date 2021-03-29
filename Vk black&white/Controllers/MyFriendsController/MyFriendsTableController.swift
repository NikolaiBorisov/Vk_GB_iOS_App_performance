//
//  AllFriendsController.swift
//  Vk black&white
//
//  Created by Macbook on 08.12.2020.
//

import UIKit
import AVFoundation
import Alamofire
import Kingfisher
import RealmSwift
import FirebaseDatabase

class MyFriendsTableController: UITableViewController {
    
    @IBAction func closePhotosView(_ unwindSegue: UIStoryboardSegue) {}
    
    //Просмотреть друзей онлайн не работает
    @IBAction func onlineSegmentControl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0: filteredFriends = self.convertToArray(results: allFriends)
        case 1: filteredFriends = self.convertToArray(results: allFriends).filter { $0.statusOnline == 1 }
        default: print("0")
        }
    }
    
    lazy var myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = .systemTeal
        return refreshControl
    }()
    
    private var allFriends: Results<User>? {
        didSet {
            tableView.reloadData()
        }
    }
    var token: NotificationToken?
    var filteredFriends = [User]()
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    var filtering: Bool {
        return searchController.isActive && !searchBarIsEmpty
        
    }
    let searchController = UISearchController(searchResultsController: nil)
    var friendSections = [FriendsSections]()
    private let networkManager = NetworkManager()
    private let realmManager = RealmManager.shared
    
    @objc func refreshData(_ sender: UIRefreshControl) {
        networkManager.loadFriends() { [weak self] (myFriends) in
            let friendsDictionary = Dictionary.init(grouping: myFriends) {
                $0.lastName.prefix(1)
            }
            self?.friendSections = friendsDictionary.map { FriendsSections(title: String($0.key), items: $0.value) }
            self?.friendSections.sort { $0.title < $1.title }
            DispatchQueue.main.async {
                try? self?.realmManager?.add(objects: myFriends)
                self?.tableView.reloadData()
            }
            sender.endRefreshing()
        }
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        allFriends = realm.objects(User.self)
        if allFriends!.isEmpty {
            networkManager.loadFriends() { [weak self] (myFriends) in
                let friendsDictionary = Dictionary.init(grouping: myFriends) {
                    $0.lastName.prefix(1)
                }
                self?.friendSections = friendsDictionary.map { FriendsSections(title: String($0.key), items: $0.value) }
                self?.friendSections.sort { $0.title < $1.title }
                
                DispatchQueue.main.async {
                    try? self?.realmManager?.add(objects: myFriends)
                    self?.tableView.reloadData()
                }
            }
        }
        self.token = allFriends?.observe{ [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                
                guard let self = self else { return }
                let friendsDictionary = Dictionary.init(grouping: self.allFriends!) {
                    $0.lastName.prefix(1)
                }
                self.friendSections = friendsDictionary.map { FriendsSections(title: String($0.key), items: $0.value) }
                self.friendSections.sort { $0.title < $1.title }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .update(_, _, _, _):
                break
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = myRefreshControl
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.setValue("Cancel", forKey: "cancelButtonText")
        navigationItem.searchController = searchController
        definesPresentationContext = true
        pairTableAndRealm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if filtering {
            return 1
        } else {
            return friendSections.count == 0 ? 1 : friendSections.count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filtering {
            return filteredFriends.count
        }
        
        if friendSections.isEmpty {
            return 0
        }
        
        return friendSections[section].items.count
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? { friendSections.map { $0.title } }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? MyFriendsCell
        else { return UITableViewCell() }
        var friends: User
        if filtering {
            friends = filteredFriends[indexPath.row]
        } else {
            friends = friendSections[indexPath.section].items[indexPath.row]
        }
        cell.configure(with: friends)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if friendSections.isEmpty {
            return nil
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 10.0))
        //make the header transparent
        view.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.3)
        let label = UILabel(frame: CGRect(x: 42, y: 5, width: tableView.frame.width - 10, height: 20.0))
        label.font = UIFont(name: "Avenir Next Medium", size: 20.0)
        label.text = friendSections[section].title
        view.addSubview(label)
        //rounding the header
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        view.layer.masksToBounds = true
        
        return view
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPhotoGallery" {
            let controller = segue.destination as! ImagesGalleryViewController
            if let index = tableView.indexPathForSelectedRow {
                var friends: User
                if filtering {
                    friends = filteredFriends[index.row]
                } else {
                    friends = friendSections[index.section].items[index.row]
                }
                controller.friend = friends
                controller.title = ("\(friends.lastName) \(friends.firstName)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MyFriendsTableController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    func filterContentForSearchText(_ searchText: String) {
        filteredFriends = allFriends!.filter({ (allFriends: User) -> Bool in
            return allFriends.lastName.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}

extension MyFriendsTableController {
    private func convertToArray <T>(results: Results<T>?) -> [T] {
        guard let results = results else { return [] }
        return Array(results)
    }
}

