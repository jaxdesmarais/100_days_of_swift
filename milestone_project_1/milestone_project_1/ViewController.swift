//
//  ViewController.swift
//  milestone_project_1
//
//  Created by Desmarais, Jax on 8/20/20.
//  Copyright © 2020 Desmarais, Jax. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    var flags = [String]()

    override func viewDidLoad() {
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupTableView()
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasSuffix("jpg") {
            	flags.append(item)
            }
        }
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Flags")
    }
}
    
    extension ViewController: UITableViewDataSource, UITableViewDelegate {
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
      }
        
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Flags", for: indexPath)
        cell.textLabel?.text = String(flags[indexPath.row].split(separator: ".").first!.uppercased())
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.imageView?.image = UIImage(named: flags[indexPath.row])
        return cell
      }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let newViewController = DetailViewController()
            newViewController.selectedFlag = flags[indexPath.row]
            newViewController.selectedFlagNumber = indexPath.item
            newViewController.totalFlags = flags.count
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
	}

