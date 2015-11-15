//
//  MovieCollectionView.swift
//  rotten-tomatoes
//
//  Created by Lê Quang Bửu on 11/15/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//

import UIKit

class MovieCollectionView: UICollectionView {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    backgroundColor = colors["primaryBackgroundColor"]
  }
}
