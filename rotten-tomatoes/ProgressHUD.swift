//
//  ProgressHUD.swift
//  rotten-tomatoes
//
//  Created by Lê Quang Bửu on 11/14/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//

import UIKit

class ProgressHUD: UIVisualEffectView {
  
  var text: String? {
    didSet {
      label.text = text
    }
  }
  let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
  let label: UILabel = UILabel()
  let blurEffect = UIBlurEffect(style: .Light)
  let vibrancyView: UIVisualEffectView
  
  init(text: String) {
    self.text = text
    self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: blurEffect))
    super.init(effect: blurEffect)
    self.setup()
  }
  
  required init(coder aDecoder: NSCoder) {
    self.text = ""
    self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: blurEffect))
    super.init(coder: aDecoder)!
    self.setup()
    
  }
  
  func setup() {
    contentView.addSubview(vibrancyView)
    vibrancyView.contentView.addSubview(activityIndictor)
    vibrancyView.contentView.addSubview(label)
    activityIndictor.startAnimating()
  }
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    if let superview = self.superview {
      
      let width = superview.frame.size.width / 2.3
      let height: CGFloat = 50.0
      self.frame = CGRectMake(superview.frame.size.width / 2 - width / 2,
        superview.frame.height / 2 - height / 2,
        width,
        height)
      vibrancyView.frame = self.bounds
      
      let activityIndicatorSize: CGFloat = 40
      activityIndictor.frame = CGRectMake(5, height / 2 - activityIndicatorSize / 2,
        activityIndicatorSize,
        activityIndicatorSize)
      
      layer.cornerRadius = 8.0
      label.text = text
      label.textAlignment = NSTextAlignment.Center
      label.frame = CGRectMake(activityIndicatorSize + 5, 0, width - activityIndicatorSize - 15, height)
      label.textColor = UIColor.grayColor()
      label.font = UIFont.boldSystemFontOfSize(16)
    }
  }
  
  func show() {
    self.hidden = false
  }
  
  func hide() {
    self.hidden = true
  }
}
