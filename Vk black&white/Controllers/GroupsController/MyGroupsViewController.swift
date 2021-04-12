//
//MyGroupsViewController.swift
//  Vk black&white
//  Created by Macbook on 08.12.2020.

import UIKit
import Alamofire
import AlamofireImage
import RealmSwift


class MyGroupsViewController: UITableViewController {
    
    private let networkManager = NetworkManager()
    private let realmManager = RealmManager.shared
    private var myGroups: Results<Group>? {
        let myGroups: Results<Group>? = realmManager?.getObjects()
        return myGroups?.sorted(byKeyPath: "id", ascending: true)
    }
    var imageService: ImageService?
    var filteredMyGroups = [Group]()
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    var filtering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    let searchController = UISearchController(searchResultsController: nil)
    var myGroupsSections = [GroupsSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageService = ImageService(container: tableView)
        networkManager.loadGroups() { [weak self] (myGroups) in
            let myGroupsDictionary = Dictionary.init(grouping: myGroups) {
                $0.name.prefix(1)
            }
            self?.myGroupsSections = myGroupsDictionary.map { GroupsSection(title: String($0.key), items: $0.value) }
            self?.myGroupsSections.sort { $0.title < $1.title }
            DispatchQueue.main.async {
                try? self?.realmManager?.add(objects: myGroups)
                self?.tableView.reloadData()
            }
        }
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.setValue("Cancel", forKey: "cancelButtonText")
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if filtering {
            return 1
        } else {
            return myGroupsSections.count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filtering {
            return filteredMyGroups.count
        }
        return myGroupsSections[section].items.count
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? { myGroupsSections.map { $0.title } }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? MyGroupsCell
        else { return UITableViewCell() }
        var groups: Group
        if filtering {
            groups = filteredMyGroups[indexPath.row]
        } else {
            groups = myGroupsSections[indexPath.section].items[indexPath.row]
        }
        //cell.configure(with: groups)
        cell.groupName.text = groups.name
        cell.groupImage.image = imageService?.photo(atIndexpath: indexPath, byUrl: groups.photo100)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if myGroupsSections.isEmpty {
            return nil
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 10.0))
        view.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.3)
        let label = UILabel(frame: CGRect(x: 42, y: 5, width: tableView.frame.width - 10, height: 20.0))
        label.font = UIFont(name: "Avenir Next Medium", size: 17.0)
        label.text = myGroupsSections[section].title
        view.addSubview(label)
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        view.layer.masksToBounds = true
        return view
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MyGroupsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredMyGroups = myGroups!.filter({ (allGroups: Group) -> Bool in
            return allGroups.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}

