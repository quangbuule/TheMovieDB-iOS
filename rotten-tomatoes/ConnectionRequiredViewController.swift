//
//  ConnectionRequiredViewController.swift
//  rotten-tomatoes
//
//  Created by Lê Quang Bửu on 11/15/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//

import UIKit

class ConnectionRequiredViewController: UIViewController {
  
  private var connectionErrorView = UIView()
  private var errorShowed = false

  override func viewDidLoad() {
    super.viewDidLoad()
    
    connectionErrorView.frame = CGRectMake(0, view.frame.height - 30, view.frame.width, 30)
    connectionErrorView.backgroundColor = colors["dangerColor"]

    let label = UILabel()
    label.text = "Connection Error"
    label.font = UIFont.systemFontOfSize(14)
    label.textColor = colors["lightColor"]
    label.textAlignment = .Center
    label.frame = connectionErrorView.bounds
    
    connectionErrorView.addSubview(label)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    connectionErrorView.removeFromSuperview()
    errorShowed = false
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  func showConnectionErrorIndicator(animated: Bool) {
    if errorShowed {
      return
    }
    
    errorShowed = true
    view.addSubview(connectionErrorView)
    
    if (animated) {
      self.connectionErrorView.frame.origin.y += 40
      
      UIView.animateWithDuration(
        0.4,
        delay: 0,
        options: .CurveEaseOut,
        animations: {
          print("ASDSAD")
          self.connectionErrorView.frame.origin.y -= 40
        },
        completion: { _ in }
      );
    }
  }
  
  func hideConnectionErrorIndicator(animated: Bool) {
    if !errorShowed {
      return
    }
    
    errorShowed = false
    
    if (!animated) {
      connectionErrorView.removeFromSuperview()
      return
    }
    
    UIView.animateWithDuration(
      0.4,
      delay: 0,
      options: .CurveEaseOut,
      animations: {
        self.connectionErrorView.frame.origin.y += 40
      },
      completion: { _ in
        self.connectionErrorView.frame.origin.y -= 40
        self.connectionErrorView.removeFromSuperview()
      }
    );
  }
}