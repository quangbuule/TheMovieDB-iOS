//
//  MovieListView.swift
//  rotten-tomatoes
//
//  Created by Lê Quang Bửu on 11/13/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//

import UIKit

class MovieListView: UITableView {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    backgroundColor = colors["primaryBackgroundColor"]
    separatorColor = colors["borderColor"]
  }
}
