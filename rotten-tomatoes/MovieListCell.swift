//
//  MovieCell.swift
//  rotten-tomatoes
//
//  Created by Lê Quang Bửu on 11/9/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieListCell: UITableViewCell {
  
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var yearLabel: UILabel!
  @IBOutlet var rateLabel: UILabel!
  @IBOutlet var synopsysLabel: UILabel!
  @IBOutlet var posterImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    backgroundColor = colors["primaryBackgroundColor"]
    titleLabel.textColor = colors["lightColor"]
    yearLabel.textColor = colors["grayColor"]
    synopsysLabel.textColor = colors["grayColor"]
    synopsysLabel.numberOfLines = 3

    rateLabel.layer.cornerRadius = 2
    rateLabel.clipsToBounds = true
    
    accessoryType = UITableViewCellAccessoryType.None
    
    let backgroundView = UIView()
    backgroundView.backgroundColor = colors["highlightBackgroundColor"]
    selectedBackgroundView = backgroundView
  }
  
  func render(movie: Movie) {
    titleLabel.text = movie.title
    yearLabel.text = String(movie.releaseYear)
    
    rateLabel.text = String(movie.voteAverage!)
    rateLabel.backgroundColor = movie.voteAverage > 5 ?
      colors["highRatingBackgroundColor"] :
      colors["lowRatingBackgroundColor"]
    rateLabel.textColor = movie.voteAverage > 5 ?
      UIColor.blackColor() :
      UIColor.whiteColor()
    
    synopsysLabel.text = movie.synopsis
    
    posterImageView.af_setImageWithURL(NSURL(string: movie.posterPath(.Small))!, imageTransition: .CrossDissolve(0.2))
  }
}
