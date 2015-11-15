//
//  Movie.swift
//  rotten-tomatoes
//
//  Created by Lê Quang Bửu on 11/10/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//

let APIKey = "1d3a19c4302b7225834283260b923e20"
let APIURLPrefix = "https://api.themoviedb.org/3"
let imageURLPrefix = "https://image.tmdb.org/t/p"

import Foundation
import Alamofire

func makeNonCacheGetRequest(string: String) -> NSURLRequest {
  return NSURLRequest(
    URL: NSURL(string: string)!,
    cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData,
    timeoutInterval: 100
  )
}

class Movie {
  
  enum ImageSize: Int {
    case Small = 0
    case Medium = 1
    case Large = 2
  }
  
  var id: Int
  var title: String
  var synopsis: String
  var posterPath: String?
  var backdropPath: String?
  var voteAverage: Float?
  var voteCount: Int = 0
  var releaseDate: NSDate?
  var runtime: Int?
  var genres: [String]?
  var tagline: String?
  
  var releaseYear: Int {
    get {
      let calendar = NSCalendar.currentCalendar()
      let components = calendar.components(.Year, fromDate: self.releaseDate!)
      
      return components.year
    }
  }
  
  var releaseDateString: String {
    get {
      let dayTimeFormatter = NSDateFormatter()
      
      dayTimeFormatter.dateFormat = "yyyy-MM-dd"
      return dayTimeFormatter.stringFromDate(self.releaseDate!)
    }
  }
  
  var formatedRuntime: String? {
    get {
      if self.runtime == nil {
        return nil
      }
      
      let minute = self.runtime! % 60
      let hour = (self.runtime! - minute) / 60
      
      return "\(hour) h" + (minute > 0 ? " \(minute) min" : "")
    }
  }
  
  init(rawData: NSDictionary) {
    let dateFormater = NSDateFormatter()
    dateFormater.dateFormat = "yyyy-MM-dd"
    
    self.id = rawData["id"] as! Int
    self.title = rawData["title"] as! String
    self.synopsis = rawData["overview"] as! String
    self.posterPath = rawData["poster_path"] as? String
    self.backdropPath = rawData["backdrop_path"] as? String
    self.voteAverage = rawData["vote_average"] as? Float
    self.voteCount = rawData["vote_count"] as! Int
    self.releaseDate = dateFormater.dateFromString(rawData["release_date"] as! String)
  }
  
  func posterPath(size: ImageSize) -> String {
    if posterPath == nil {
      return "http://www.movli.com/images/movie-default.jpg"
    }
    
    switch size {
    case .Small:
      return  "\(imageURLPrefix)/w185\(posterPath!)"
      
    default:
      return  "\(imageURLPrefix)/w500\(posterPath!)"
    }
  }
  
  
  func backdropPath(size: ImageSize) -> String {
    if backdropPath == nil {
      return "http://en.evian-tourisme.com/images/prestataires/cinema-copier-6137.jpg"
    }
    
    
    switch size {
    case .Small:
      return  "\(imageURLPrefix)/w300\(backdropPath!)"
      
    default:
      return  "\(imageURLPrefix)/w780\(backdropPath!)"
    }
  }
  
  func fetchMoreDetails(callback: (Movie) -> Void) {
    Alamofire.request(.GET, "\(APIURLPrefix)/movie/\(id)", parameters: ["api_key": APIKey])
      .responseJSON { response in
        if let JSON = response.result.value {
          self.runtime = JSON["runtime"] as? Int
          self.genres = (JSON["genres"] as? [NSDictionary])?.map { genreRawData in
            return genreRawData["name"] as! String
          }
          self.tagline = JSON["tagline"] as? String
          
          
          callback(self)
        }
    }
  }
}

class MovieCollection {
  
  var movies = [Movie]()
  
  var fetching: Bool = false
  var failed: Bool = false
  var done: Bool = false
  
  private var requestURLString = "\(APIURLPrefix)/discover/movie"
  private var parameters: Dictionary<String, AnyObject> = [
    "api_key": APIKey,
    "sort_by": "popularity.desc"
  ]
  private var currentPage: Int = -1
  
  var count: Int {
    get {
      return self.movies.count
    }
  }
  
  init(searchFor: String) {
    requestURLString = "\(APIURLPrefix)/search/movie"
    parameters["query"] = searchFor
  }
  
  init() {}
  
  func fetch(done: (MovieCollection) -> Void, fail: (NSError?) -> Void) {
    if fetching {
      // TODO: Handle noop
      return
    }
    
    fetching = true
    
    let request = {() -> Alamofire.Request in
      let mutableRequest = Alamofire.request(.GET, self.requestURLString, parameters: self.parameters)
        .request as! NSMutableURLRequest
      
      mutableRequest.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
      return Alamofire.request(mutableRequest)
    }()
    
    request
      .responseJSON { response in
        if let JSON = response.result.value {
          self.fetching = false
          self.failed = false
          self.done = true
          
          self.currentPage = JSON["page"] as! Int
          self.movies = (JSON["results"] as! [NSDictionary]).map { movieRawData in
            return Movie(rawData: movieRawData)
          }
          
          done(self)
        }
        
        if let error = response.result.error {
          self.fetching = false
          self.failed = true
          
          fail(error)
        }
    }
  }
  
  
  func fetchMore(done: (MovieCollection) -> Void, fail: (NSError?) -> Void) {
    if fetching {
      // TODO: Handle noop
      return
    }
    
    fetching = true
    
    self.parameters["page"] = currentPage + 1
    
    let request = {() -> Alamofire.Request in
      let mutableRequest = Alamofire.request(.GET, self.requestURLString, parameters: self.parameters)
        .request as! NSMutableURLRequest
      
      mutableRequest.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
      return Alamofire.request(mutableRequest)
    }()

    request
      .responseJSON { response in
        if let JSON = response.result.value {
          self.fetching = false
          self.failed = false
          
          self.currentPage = JSON["page"] as! Int
          self.movies += (JSON["results"] as! [NSDictionary]).map { movieRawData in
            return Movie(rawData: movieRawData)
          }
          
          done(self)
        }
        
        if let error = response.result.error {
          self.fetching = false
          self.failed = true
          
          fail(error)
        }
    }
  }
  
  func get(index: Int) -> Movie? {
    return index < movies.count ? self.movies[index] : nil
  }
}

