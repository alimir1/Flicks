//
//  ViewController.swift
//  Flicks
//
//  Created by Ali Mir on 9/13/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit
import MBProgressHUD

class MoviesViewController: UIViewController, TheMovieDBDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    var movies: [Movie] = []
    
    var endpoint = ""
    
    var movieAPI: TheMovieDBApi!
    
    var errorBannerView: UIView!
    
    var isErrorBannerDisplayed: Bool! {
        didSet {
            errorBannerView.isHidden = !isErrorBannerDisplayed
        }
    }
    
    
    var NetworkErrorBanner: UIView {
        let errorView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 45))
        errorView.backgroundColor = .darkGray
        let errorLabel = UILabel(frame: CGRect(x: errorView.bounds.origin.x + 8, y: errorView.bounds.origin.y + 8, width: errorView.bounds.width - (8*2), height: errorView.bounds.height - (8*2)))
        errorLabel.textColor = .white
        let mutableString = NSMutableAttributedString(attributedString: NSAttributedString(string: "   ", attributes: [NSFontAttributeName : UIFont(name: "FontAwesome", size: 17)!, NSForegroundColorAttributeName : UIColor.lightGray]))
        mutableString.append(NSAttributedString(string: "Network Error", attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Bold", size: 15)!, NSForegroundColorAttributeName : UIColor.white]))
        errorLabel.attributedText = mutableString
        errorLabel.textAlignment = .center
        errorView.addSubview(errorLabel)
        return errorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        movieAPI = TheMovieDBApi(endpoint: endpoint)
        movieAPI.delegate = self
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.fetchDataFromWeb), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        fetchDataFromWeb()
        
        self.edgesForExtendedLayout = []
        
        errorBannerView = NetworkErrorBanner
        isErrorBannerDisplayed = false
        self.view.addSubview(errorBannerView)
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
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            self.tableView.reloadData()
        }
        isErrorBannerDisplayed = false
    }
    
    func theMovieDB(didFailWithError error: Error) {
        MBProgressHUD.hide(for: self.view, animated: true)
        DispatchQueue.main.async {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
        isErrorBannerDisplayed = true
    }
    
    @objc func fetchDataFromWeb() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        movieAPI.startUpdatingMovies()
    }

}


extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flickCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        cell.titleLabel.text = movie.title
        cell.overViewLabel.text = movie.overview
        cell.releaseYearLabel.text = movie.releaseYear
        cell.averageVoteLabel.text = String(format: "%.1f", movie.avgRating ?? 0)
        if let posterImageURL = movie.posterImageURLMedium {
            cell.posterImageView.setImageWith(posterImageURL)
        } else {
            // FIXME: - Set placeholder
        }
        
        
        return cell
    }
}
