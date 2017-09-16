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

class MoviesViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    // MARK: - Stored Properties
    
    var collectionView: UICollectionView!
    var changeLayoutBarButtonItem: UIBarButtonItem!
    var tableViewRefreshControl: UIRefreshControl!
    var collectionViewRefreshControl: UIRefreshControl!
    var endpoint = ""
    var movieAPI: TheMovieDBApi!
    var tableViewDataSource = MoviesTableViewDataSource()
    var collectionViewDataSource = MoviesCollectionViewDataSource()
    var errorBannerView: UIView!
    var movies = [Movie]()
    
    // MARK: - Property Observers
    
    
    var filteredMovies = [Movie]() {
        didSet {
            tableViewDataSource.movies = filteredMovies
            collectionViewDataSource.movies = filteredMovies
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
    
    var isErrorBannerDisplayed: Bool! {
        didSet {
            errorBannerView.isHidden = !isErrorBannerDisplayed
        }
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        movieAPI = TheMovieDBApi(endpoint: endpoint)
        movieAPI.delegate = self
        fetchDataFromWeb()
        self.edgesForExtendedLayout = []
        isErrorBannerDisplayed = false
        displayType = .list
        searchBar.delegate = self
    }
    
    // MARK: - Target Action
    
    func switchLayout() {
        switch displayType {
        case .grid:
            changeLayoutBarButtonItem.title = "Grid"
            displayType = .list
        case .list:
            changeLayoutBarButtonItem.title = "List"
            displayType = .grid
        }
    }
    
    func refreshData() {
        fetchDataFromWeb()
    }
}


// MARK: - Network Requests

extension MoviesViewController {
    func fetchDataFromWeb() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        movieAPI.startUpdatingMovies()
    }
}

// MARK: - SearchBar Delegate

extension MoviesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMovies = searchText.isEmpty ? movies :  movies.filter {($0.title ?? "").range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

// MARK: - TheMovieDbApi Delegate

extension MoviesViewController: TheMovieDBDelegate {
    func theMovieDB(didFinishUpdatingMovies movies: [Movie]) {
        MBProgressHUD.hide(for: self.view, animated: true)
        self.movies = movies
        self.filteredMovies = movies
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
}

// MARK: - Navigation

extension MoviesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieDetail" {
            let movieDetailVC = segue.destination as! MovieDetailViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            movieDetailVC.movie = movies[indexPath!.row]
        }
    }
}

// MARK: - TableView Delegate

extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - Helpers

extension MoviesViewController {
    func setupViews() {
        setupErrorBannerView()
        setupCollectionView()
        setupTableView()
        setupRefreshControls()
        setupChangeLayoutBarButton()
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: GridLayout())
        collectionView.backgroundColor = .white
        collectionView.register(MovieCollectionCell.self, forCellWithReuseIdentifier: "movieCollectionCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = collectionViewDataSource
        self.view.addSubview(collectionView)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = tableViewDataSource
    }
    
    func setupRefreshControls() {
        collectionViewRefreshControl = UIRefreshControl()
        collectionViewRefreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        collectionView.insertSubview(collectionViewRefreshControl, at: 0)
        
        
        tableViewRefreshControl = UIRefreshControl()
        tableViewRefreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        tableView.insertSubview(tableViewRefreshControl, at: 0)
    }
    
    func setupChangeLayoutBarButton() {
        changeLayoutBarButtonItem = UIBarButtonItem(title: "Grid", style: .plain, target: self, action: #selector(self.switchLayout))
        self.navigationItem.leftBarButtonItem = changeLayoutBarButtonItem
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
