//
//  MovieDetailInfoView.swift
//  rotten-tomatoes
//
//  Created by Lê Quang Bửu on 11/14/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//

import UIKit

class MovieDetailInfoView: UIView {
  
  func createDetailView(term: String, defination: String) -> UIView {
    let view = UIView()
    let termLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 80, height: 40))
    let definationLabel = UILabel(frame: CGRect(x: 70, y: 0, width: 240, height: 40))
    
    termLabel.font = termLabel.font.fontWithSize(14)
    termLabel.text = term
    termLabel.textColor = colors["grayColor"]
    
    definationLabel.font = termLabel.font.fontWithSize(14)
    definationLabel.text = defination
    definationLabel.textAlignment = NSTextAlignment.Right
    definationLabel.textColor = colors["lightColor"]
    
    view.addSubview(termLabel)
    view.addSubview(definationLabel)
    
    return view
  }
  
  func render(movie: Movie) {
    let releaseYearDetailView = createDetailView("Year", defination: movie.releaseDateString)
    
    releaseYearDetailView.frame = CGRect(x: 0, y: 50, width: (superview?.frame
      .width)!, height: 40)
    addSubview(releaseYearDetailView)
  }
}