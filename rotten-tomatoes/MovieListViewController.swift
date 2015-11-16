//
//  ViewController.swift
//  rotten-tomatoes
//
//  Created by Lê Quang Bửu on 11/9/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieListViewController: ConnectionRequiredViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
  
  @IBOutlet var tableView: MovieListView!
  @IBOutlet var collectionView: MovieCollectionView!
  @IBOutlet var searchBar: UISearchBar!
  @IBOutlet var viewTypeToggle: UIBarButtonItem!
  
  let refreshControl = UIRefreshControl()
  let loadingMoreIndicator = UIActivityIndicatorView()
  var movieCollection = MovieCollection()
  var currentListView: UIScrollView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.barStyle = .Black
    
    loadingMoreIndicator.color = colors["lightColor"]
    loadingMoreIndicator.frame = CGRectMake(0, 0, tableView.frame.width, 44)
    
    viewTypeToggle.image = UIImage(named: "collection-view-icon")
    viewTypeToggle.title = nil
    
    refreshControl.tintColor = colors["grayColor"]
    refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)

    searchBar.tintColor = colors["grayColor"]
    searchBar.barStyle = .Black
    searchBar.placeholder = "Find your favorite movie..."
    searchBar.delegate = self
    searchBar.enablesReturnKeyAutomatically = false
    
    tableView.dataSource = self
    tableView.delegate = self
    
    collectionView.dataSource = self
    collectionView.delegate = self
    
    useTableView()
    
    fetchMovies(){
      self.scrollToTop(false)
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    refreshControl.endRefreshing()
    if tableView.indexPathForSelectedRow != nil {
      tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: false)
    }
  }
  
  func useTableView() {
    collectionView.hidden = true
    tableView.hidden = false
    
    refreshControl.removeFromSuperview()
    searchBar.removeFromSuperview()
    
    tableView.addSubview(refreshControl)
    tableView.addSubview(searchBar)
    tableView.contentInset = UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: 0, right: 0)
    
    viewTypeToggle.image = UIImage(named: "collection-view-icon")
    
    currentListView = tableView
    
    reloadData()
    scrollToTop(false)
  }
  
  func useCollectionView() {
    tableView.hidden = true
    collectionView.hidden = false
    
    refreshControl.removeFromSuperview()
    searchBar.removeFromSuperview()
    
    collectionView.addSubview(refreshControl)
    collectionView.addSubview(searchBar)
    collectionView.contentInset = UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: 0, right: 0)
    
    viewTypeToggle.image = UIImage(named: "list-view-icon")
    
    currentListView = collectionView
    
    reloadData()
    scrollToTop(false)
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movieCollection.count + 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if let movie = movieCollection.get(indexPath.row) {
      let cell = tableView.dequeueReusableCellWithIdentifier("movieListCell") as! MovieListCell
      cell.render(movie)
      return cell
      
    } else if movieCollection.fetching {
      let loadingCell = UITableViewCell()
      let loadingMoreIndicator = UIActivityIndicatorView()
      
      loadingMoreIndicator.color = colors["lightColor"]
      loadingMoreIndicator.frame = CGRectMake(150, 10, 20, 20)
      loadingMoreIndicator.startAnimating()
      
      loadingCell.backgroundColor = colors["primaryBackgroundColor"]
      loadingCell.addSubview(loadingMoreIndicator)
      return loadingCell
      
    } else {
      let cell = UITableViewCell();
      cell.backgroundColor = colors["primaryBackgroundColor"]
      return cell
    }
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return movieCollection.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let movie = movieCollection.get(indexPath.row)!
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("movieCollectionCell", forIndexPath: indexPath) as! MovieCollectionCell
    
    cell.render(movie)
    return cell
  }
  
  func scrollToTop(animated: Bool) {
    currentListView!.setContentOffset(CGPoint(x:0, y: -topLayoutGuide.length), animated: animated)
  }
  
  func reloadData() {
    if currentListView == tableView {
      tableView.reloadData()
    }
    
    if currentListView == collectionView {
      collectionView.reloadData()
    }
    
    switch movieCollection.type {
    case .Popular:
      title = "Popular"
      break;
    
    case .Search:
      title = "Search"
      break;
      
    case .TopRated:
      title = "Top Rated"
      break;
    }
  }
  
  // MARK: Navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    var selectedIdx: Int?
    
    if segue.identifier == "fromMovieTableCell" {
      selectedIdx = tableView.indexPathForSelectedRow!.row
    }
    
    if segue.identifier == "fromMovieCollectionCell" {
      let cell = sender as! MovieCollectionCell
      selectedIdx = collectionView.indexPathForCell(cell)!.row
    }
    
    let detailViewController = segue.destinationViewController as! MovieDetailViewController
    detailViewController.movie = movieCollection.get(selectedIdx!)
  }
  
  // MARK: Fetching data
  func fetchMovies(callback: () -> Void) {
    movieCollection.fetch(
      { _ in
        self.reloadData()
        self.hideConnectionErrorIndicator(true)
        callback()
      },
      fail: { _ in
        self.showConnectionErrorIndicator(true)
        self.reloadData()
        callback()
      }
    )
  }
  
  func fetchMoreMovies() {
    if !movieCollection.done {
      return
    }
    
    movieCollection.fetchMore({ _ in
      self.reloadData()
      self.hideConnectionErrorIndicator(true)
    },
      fail: { _ in
        self.showConnectionErrorIndicator(true)
        self.tableView.reloadData()
    })
  }
  
  func refresh(sender: AnyObject) {
    refreshControl.beginRefreshing()
    
    fetchMovies() {
      self.refreshControl.endRefreshing()
      self.scrollToTop(true)
    }
  }
  
  func fetchMoreMoviesIfNeeded(scrollView: UIScrollView) {
    let currentOffset = scrollView.contentOffset.y;
    let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (maximumOffset - currentOffset <= 100) {
      self.fetchMoreMovies()
    }
  }
  
  // MARK: TableView event handlers
  func scrollViewDidScroll(scrollView: UIScrollView) {
    view.endEditing(true)
    if (!movieCollection.failed) {
      fetchMoreMoviesIfNeeded(scrollView)
    }
  }
  
  func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    fetchMoreMoviesIfNeeded(scrollView)
  }
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    fetchMoreMoviesIfNeeded(scrollView)
  }
  
  // MARK: SearchBar event handlers
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    view.endEditing(true)
    
    movieCollection = searchBar.text! != "" ?
      MovieCollection(searchFor: searchBar.text!) :
      MovieCollection()
    
    reloadData()
    fetchMovies() {}
  }
  
  @IBAction func handleViewTypeToggleClick(sender: UIBarButtonItem) {
    if (currentListView == tableView) {
      useCollectionView()
      
    } else {
      useTableView()
    }
  }
}
