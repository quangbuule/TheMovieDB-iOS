//
//  MovileDetailViewController.swift
//  rotten-tomatoes
//
//  Created by Lê Quang Bửu on 11/14/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
  
  @IBOutlet var detailView: MovieDetailView!
  var scrollView = UIScrollView()
  var movie: Movie!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = movie.title
    scrollView.frame = view.frame
    scrollView.addSubview(detailView)
    
    detailView.render(movie)
    
    detailView.removeFromSuperview()
    scrollView.addSubview(detailView)
    
    scrollView.contentSize = CGSize(width: -1, height: detailView.contentHeight)
    
    view = scrollView
  }
}