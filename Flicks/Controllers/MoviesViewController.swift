//
//  ViewController.swift
//  Flicks
//
//  Created by Ali Mir on 9/13/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit
import MBProgressHUD

enum LayoutType {
    case list
    case grid
}

class MoviesViewController: UIViewController, TheMovieDBDelegate {
    
    @IBOutlet var tableView: UITableView!
    var collectionView: UICollectionView!
    
    var changeLayoutBarButtonItem: UIBarButtonItem!
    
    var tableViewRefreshControl: UIRefreshControl!
    var collectionViewRefreshControl: UIRefreshControl!
    
    var movies = [Movie]() {
        didSet {
            tableViewDataSource.movies = movies
            collectionViewDataSource.movies = movies
            tableView.reloadData()
            collectionView.reloadData()
        }
    }
    
    var displayType: LayoutType = .list {
        didSet {
            switch displayType {
            case .list:
                self.tableView.isHidden = false
                self.collectionView.isHidden = true
            case .grid:
                self.tableView.isHidden = true
                self.collectionView.isHidden = false
            }
        }
    }
    
    var endpoint = ""
    
    var movieAPI: TheMovieDBApi!
    
    var tableViewDataSource = MoviesTableViewDataSource()
    var collectionViewDataSource = MoviesCollectionViewDataSource()
    
    var errorBannerView: UIView!
    
    var isErrorBannerDisplayed: Bool! {
        didSet {
            errorBannerView.isHidden = !isErrorBannerDisplayed
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: GridLayout())
        collectionView.backgroundColor = .white
        collectionView.register(MovieCollectionCell.self, forCellWithReuseIdentifier: "movieCollectionCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = collectionViewDataSource
        self.view.addSubview(collectionView)
        
        tableView.delegate = self
        tableView.dataSource = tableViewDataSource
        movieAPI = TheMovieDBApi(endpoint: endpoint)
        movieAPI.delegate = self
        
        
        collectionViewRefreshControl = UIRefreshControl()
        collectionViewRefreshControl.addTarget(self, action: #selector(self.fetchDataFromWeb), for: .valueChanged)
        collectionView.insertSubview(collectionViewRefreshControl, at: 0)
        
        
        tableViewRefreshControl = UIRefreshControl()
        tableViewRefreshControl.addTarget(self, action: #selector(self.fetchDataFromWeb), for: .valueChanged)
        tableView.insertSubview(tableViewRefreshControl, at: 0)
        
        fetchDataFromWeb()
        
        self.edgesForExtendedLayout = []
        
        setupErrorBannerView()
        isErrorBannerDisplayed = false
        
        displayType = .list
        
        setupChangeLayoutBarButton()
        
        
    }
    
    func setupChangeLayoutBarButton() {
        changeLayoutBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.switchLayout))
        changeLayoutBarButtonItem.title = "Change Layout"
        self.navigationItem.leftBarButtonItem = changeLayoutBarButtonItem
    }
    
    func switchLayout() {
        switch displayType {
        case .grid:
            displayType = .list
        case .list:
            displayType = .grid
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieDetail" {
            let movieDetailVC = segue.destination as! MovieDetailViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            movieDetailVC.movie = movies[indexPath!.row]
        }
    }
    
    func theMovieDB(didFinishUpdatingMovies movies: [Movie]) {
        MBProgressHUD.hide(for: self.view, animated: true)
        self.movies = movies
        DispatchQueue.main.async {
            self.tableViewRefreshControl.endRefreshing()
            self.collectionViewRefreshControl.endRefreshing()
        }
        isErrorBannerDisplayed = false
    }
    
    func theMovieDB(didFailWithError error: Error) {
        MBProgressHUD.hide(for: self.view, animated: true)
        DispatchQueue.main.async {
            self.tableViewRefreshControl.endRefreshing()
            self.collectionViewRefreshControl.endRefreshing()
        }
        isErrorBannerDisplayed = true
    }
    
    @objc func fetchDataFromWeb() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        movieAPI.startUpdatingMovies()
    }
    
    func setupErrorBannerView() {
        let errorView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 45))
        errorView.backgroundColor = .darkGray
        let errorLabel = UILabel(frame: CGRect(x: errorView.bounds.origin.x + 8, y: errorView.bounds.origin.y + 8, width: errorView.bounds.width - 8, height: errorView.bounds.height - 8))
        errorLabel.textColor = .white
        let mutableString = NSMutableAttributedString(attributedString: NSAttributedString(string: "   ", attributes: [NSFontAttributeName : UIFont(name: "FontAwesome", size: 17)!, NSForegroundColorAttributeName : UIColor.lightGray]))
        mutableString.append(NSAttributedString(string: "Network Error", attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Bold", size: 15)!, NSForegroundColorAttributeName : UIColor.white]))
        errorLabel.attributedText = mutableString
        errorLabel.textAlignment = .center
        errorView.addSubview(errorLabel)
        errorBannerView = errorView
        self.view.addSubview(errorBannerView)
    }

}


extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
