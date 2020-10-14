//
//  ViewController.swift
//  project7_100_days_of_code
//
//  Created by Desmarais, Jax on 10/12/20.
//  Copyright © 2020 Desmarais, Jax. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    var safeArea: UILayoutGuide!
    var petitions: [Petition] = []
    var filteredPetitions: [Petition] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        safeArea = view.layoutMarginsGuide
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
    
        searchController.searchResultsUpdater = self
        self.definesPresentationContext = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        navigationItem.titleView = searchController.searchBar
        
        searchController.hidesNavigationBarDuringPresentation = false
        
        setupTableView()
        createTabBarController()
        
        let urlString: String
            
        if navigationController?.tabBarItem.tag == 0 {
           urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        showError()
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was an error loading the feed. Please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
        
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
	func setupTableView() {
		view.addSubview(tableView)
   		tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
   		tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
   		tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
   		tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
       tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Petitions")
	}
    
    func createTabBarController() {
        let tabBarController = UITabBarController()
        
        let mostRecentViewController = UIViewController()
        mostRecentViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)
        
        let topRatedViewController = UIViewController()
        topRatedViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 1)
        
        tabBarController.viewControllers = [mostRecentViewController, topRatedViewController]
        self.view.addSubview(tabBarController.view)
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "This data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func filterPetitions(for searchText: String) {
        filteredPetitions = petitions.filter { $0.body.contains(searchText) }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterPetitions(for: searchText)
            tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchController.isActive ? filteredPetitions.count : petitions.count
  }
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Petitions", for: indexPath)
    let petition = searchController.isActive ? filteredPetitions[indexPath.row] : petitions[indexPath.row]
    cell.textLabel?.text = petition.title
    cell.detailTextLabel?.text = petition.body
    cell.accessoryType = .disclosureIndicator
    return cell
  }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsViewController()
        vc.detailItem = petitions[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
