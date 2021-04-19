//
// NotMyGroupsViewController.swift
//  Vk black&white
//  Created by Macbook on 08.12.2020.

import UIKit
import AlamofireImage
import Kingfisher

class AllGroupsTableController: UITableViewController {
    
    //@IBOutlet weak var searchBar: UISearchBar!
    
    var imageService: ImageService?
    let networkManager = NetworkManager()
    var allGroups = [Group]()
    var filteredGroups = [Group]()
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    var filtering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    let searchController = UISearchController(searchResultsController: nil)
    var allGroupsSections = [GroupsSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageService = ImageService(container: tableView)
        networkManager.searchGroup(token: Session.shared.token, group: " ") { [weak self] (allGroups) in
            self?.allGroups = allGroups
            let allGroupsDictionary = Dictionary.init(grouping: allGroups) {
                $0.name.prefix(1)
            }
            self?.allGroupsSections = allGroupsDictionary.map { GroupsSection(title: String($0.key), items: $0.value) }
            self?.allGroupsSections.sort { $0.title < $1.title }
            DispatchQueue.main.async {
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
            return allGroupsSections.count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filtering {
            return filteredGroups.count
        }
        return allGroupsSections[section].items.count
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? { allGroupsSections.map { $0.title } }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewGroupCell", for: indexPath) as? MyGroupsCell
        else { return UITableViewCell() }
        var groups: Group
        if filtering {
            groups = filteredGroups[indexPath.row]
        } else {
            groups = allGroupsSections[indexPath.section].items[indexPath.row]
        }
        //cell.configure(with: groups)
        cell.groupName.text = groups.name
        cell.groupImage.image = imageService?.photo(atIndexpath: indexPath, byUrl: groups.photo100)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if allGroupsSections.isEmpty {
            return nil
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 10.0))
        view.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.3)
        let label = UILabel(frame: CGRect(x: 42, y: 5, width: tableView.frame.width - 10, height: 20.0))
        label.font = UIFont(name: "Avenir Next Medium", size: 17.0)
        label.text = allGroupsSections[section].title
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

extension AllGroupsTableController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        networkManager.searchGroup(token: Session.shared.token, group: searchText.lowercased()) { [weak self] groups in
            self?.filteredGroups = groups
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        tableView.reloadData()
    }
}
