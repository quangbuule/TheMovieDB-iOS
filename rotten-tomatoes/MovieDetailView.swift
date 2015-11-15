//
//  DetailScrollView.swift
//  rotten-tomatoes
//
//  Created by Lê Quang Bửu on 11/14/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailView: UIView {
  
  @IBOutlet var backdropImageView: UIImageView!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var posterImageView: UIImageView!
  @IBOutlet var rateLabel: UILabel!
  @IBOutlet var detailBackgroundView: UIView!
  @IBOutlet var runtimeLabel: UILabel!
  @IBOutlet var genresLabel: UILabel!
  @IBOutlet var taglineLabel: UILabel!
  @IBOutlet var overviewLabel: UILabel!
  @IBOutlet var synopsisLabel: UILabel!
  
  let vibrancyView: UIVisualEffectView
  let detailBackdropImageView: UIImageView!
  
  var contentHeight: CGFloat {
    get {
      return synopsisLabel.frame.maxY + 10
    }
  }

  required init(coder aDecoder: NSCoder) {
    let blurEffect = UIBlurEffect(style: .Dark)
    let childView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: blurEffect))

    vibrancyView = UIVisualEffectView(effect: blurEffect)
    detailBackdropImageView = UIImageView()
    
    super.init(coder: aDecoder)!
    
    childView.frame = self.bounds
    vibrancyView.addSubview(childView)
  }
  
  func getTitleString(movie: Movie) -> NSMutableAttributedString {
    let string = "\(movie.title) \(movie.releaseYear)"
    let aString = NSMutableAttributedString(string: string)
    
    
    let titleRange = NSRange(
      location: 0,
      length: movie.title.characters.count
    )
    let yearRange = NSRange(
      location: titleRange.length,
      length: string.characters.count - titleRange.length
    )
    
    aString.addAttributes([
      NSForegroundColorAttributeName: colors["primaryColor"]!,
      NSFontAttributeName: UIFont.systemFontOfSize(17)
      ], range: titleRange);
    
    aString.addAttributes([
      NSForegroundColorAttributeName: colors["lightColor"]!,
      NSFontAttributeName: UIFont.systemFontOfSize(12)
      ], range: yearRange);
    
    return aString
  }
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    if self.superview != nil {
      backgroundColor = colors["primaryBackgroundColor"]
      
      runtimeLabel.textColor = colors["lightColor"]
      genresLabel.textColor = colors["grayColor"]
      taglineLabel.textColor = colors["lightColor"]
      overviewLabel.textColor = colors["lightColor"]
      
      synopsisLabel.textColor = colors["grayColor"]
      synopsisLabel.numberOfLines = 0
      
      vibrancyView.frame = CGRectMake(
        0, 0,
        detailBackgroundView.frame.width,
        detailBackgroundView.frame.height
      )
      detailBackdropImageView.frame = vibrancyView.frame
      
      detailBackgroundView.insertSubview(vibrancyView, atIndex: 0)
      detailBackgroundView.insertSubview(detailBackdropImageView, atIndex: 0)
    }
  }
  
  func render(movie: Movie) {
    
    backdropImageView.af_setImageWithURL(
      NSURL(string: movie.backdropPath(.Medium))!,
      imageTransition: .CrossDissolve(0.2)
    )
    detailBackdropImageView.af_setImageWithURL(
      NSURL(string: movie.backdropPath(.Medium))!,
      imageTransition: .CrossDissolve(0.2)
    )
    posterImageView.af_setImageWithURL(
      NSURL(string: movie.posterPath(.Small))!,
      imageTransition: .CrossDissolve(0.2)
    )
    titleLabel.attributedText = getTitleString(movie)
    
    rateLabel.text = String(movie.voteAverage!)
    rateLabel.backgroundColor = movie.voteAverage > 5 ?
      colors["highRatingBackgroundColor"] :
      colors["lowRatingBackgroundColor"]
    rateLabel.textColor = movie.voteAverage > 5 ?
      UIColor.blackColor() :
      UIColor.whiteColor()

    synopsisLabel.text = movie.synopsis
    synopsisLabel.sizeToFit()
    
    if movie.genres != nil {
      genresLabel.text = movie.genres!.joinWithSeparator(", ")
      runtimeLabel.text = movie.formatedRuntime
      taglineLabel.text = movie.tagline
      
      if taglineLabel.text == "" {
        taglineLabel.text = "---"
      }
      
    } else {
      movie.fetchMoreDetails { movie in
        self.render(movie)
      }
    }
  }
}
