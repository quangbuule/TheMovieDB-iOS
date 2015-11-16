//
//  MovieTabBarController.swift
//  rotten-tomatoes
//
//  Created by Lê Quang Bửu on 11/16/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//

import UIKit

class MovieTabBarController: UITabBarController {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    tabBar.barStyle = .Black
    
    let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    let popularViewController = storyboard.instantiateViewControllerWithIdentifier("navController") as! UINavigationController
    let topRatedViewController = storyboard.instantiateViewControllerWithIdentifier("navController") as! UINavigationController
    
    let popularItem = UITabBarItem(title: "Popular", image: UIImage(named: "popular-icon"), tag: 0)
    let topRatedItem = UITabBarItem(title: "Top rated", image: UIImage(named: "top-rated-icon"), tag: 0)
    
    popularViewController.tabBarItem = popularItem
    topRatedViewController.tabBarItem = topRatedItem
    
    (topRatedViewController.viewControllers[0] as! MovieListViewController).movieCollection = MovieCollection(topRated: true)
    
    viewControllers = [popularViewController, topRatedViewController]
  }
}
