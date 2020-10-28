//
//  TabBarController.swift
//  project7_100_days_of_code
//
//  Created by Desmarais, Jax on 10/26/20.
//  Copyright © 2020 Desmarais, Jax. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.viewControllers = [mostRecentTabBar, topRatedTabBar].map{UINavigationController(rootViewController: $0)}
    }
    
    lazy public var mostRecentTabBar: ViewController = {
        let mostRecentTabBar = ViewController()
        let tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)
        mostRecentTabBar.tabBarItem = tabBarItem
        return mostRecentTabBar
    }()
    
    lazy public var topRatedTabBar: ViewController = {
        let topRatedTabBar = ViewController()
        let tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 1)
        topRatedTabBar.tabBarItem = tabBarItem
        return topRatedTabBar
    }()
}

//extension TabBarController: UITabBarControllerDelegate {
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        print("Selected \(viewController.title!)")
//    }
//}
