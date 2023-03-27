//
//  ViewController.swift
//  Netflix Clone
//
//  Created by Jackson Matheus on 18/03/23.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        
        let tab1 = UINavigationController(rootViewController: HomeViewController())
        tab1.tabBarItem.image = UIImage(systemName: "house")
        tab1.title = "Home"
        
        
        let tab2 = UINavigationController(rootViewController: UpcomingViewController())
        tab2.tabBarItem.image = UIImage(systemName: "play.circle")
        tab2.title = "Coming son"
        
        let tab3 = UINavigationController(rootViewController: SearchViewController())
        tab3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        tab3.title = "Top Search"
        
        let tab4 = UINavigationController(rootViewController: DonwloadsViewController())
        tab4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        tab4.title = "Downloads"
        
        
        
        
        self.tabBar.tintColor = .label
        
        setViewControllers([tab1, tab2, tab3, tab4], animated: true)
    }


}

