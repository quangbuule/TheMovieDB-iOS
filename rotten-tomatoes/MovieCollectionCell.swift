//
//  File.swift
//  rotten-tomatoes
//
//  Created by Lê Quang Bửu on 11/15/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//

import UIKit

class MovieCollectionCell: UICollectionViewCell {
  
  @IBOutlet var posterImageView: UIImageView!
  @IBOutlet var titleBackgroundView: UIView!
  @IBOutlet var yearLabel: UILabel!
  @IBOutlet var rateLabel: UILabel!

  let vibrancyView: UIVisualEffectView
  let detailBackdropImageView: UIImageView!
  
  required init?(coder aDecoder: NSCoder) {
  let blurEffect = UIBlurEffect(style: .Dark)
  let childView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: blurEffect))
    
    vibrancyView = UIVisualEffectView(effect: blurEffect)
    detailBackdropImageView = UIImageView()
    
    super.init(coder: aDecoder)!
    
    childView.frame = self.bounds
    vibrancyView.addSubview(childView)
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    
    yearLabel.textColor = colors["lightColor"]
    
    rateLabel.layer.cornerRadius = 2
    rateLabel.clipsToBounds = true
    
    vibrancyView.frame = titleBackgroundView.bounds
    detailBackdropImageView.frame = vibrancyView.frame
    
    titleBackgroundView.insertSubview(vibrancyView, atIndex: 0)
    titleBackgroundView.insertSubview(detailBackdropImageView, atIndex: 0)
  }
  
  func render(movie: Movie) {
    posterImageView.af_setImageWithURL(NSURL(string: movie.posterPath(.Medium))!, imageTransition: .CrossDissolve(0.2))
    detailBackdropImageView.af_setImageWithURL(NSURL(string: movie.posterPath(.Medium))!, imageTransition: .CrossDissolve(0.2))
    
    yearLabel.text = "\(movie.releaseYear)"
    
    rateLabel.backgroundColor = movie.voteAverage > 5 ?
      colors["highRatingBackgroundColor"] :
      colors["lowRatingBackgroundColor"]
    rateLabel.textColor = movie.voteAverage > 5 ?
      UIColor.blackColor() :
      UIColor.whiteColor()
    rateLabel.text = String(movie.voteAverage!)
  }
}