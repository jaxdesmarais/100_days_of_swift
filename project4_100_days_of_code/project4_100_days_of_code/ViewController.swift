//
//  ViewController.swift
//  project4_100_days_of_code
//
//  Created by Desmarais, Jax on 8/24/20.
//  Copyright © 2020 Desmarais, Jax. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let tableView = UITableView()
    var websites = ["google.com", "apple.com"]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Websites to View"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupTableView()
    }
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Website")
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return websites.count
  }
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
    cell.textLabel?.text = websites[indexPath.row]
    cell.accessoryType = .disclosureIndicator
    cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
    return cell
  }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newViewController = DetailViewController()
        newViewController.selectedPictureNumber = indexPath.item
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
}
