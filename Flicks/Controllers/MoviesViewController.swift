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
    }
    
    func theMovieDB(didFailWithError error: Error) {
        MBProgressHUD.hide(for: self.view, animated: true)
        DispatchQueue.main.async {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
        
        let alertCtrl = UIAlertController(title: "Yikes!", message: "\(error.localizedDescription)", preferredStyle: .alert)
        alertCtrl.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertCtrl, animated: true, completion: nil)
    }
    
    @objc func fetchDataFromWeb() {
        if !self.refreshControl.isRefreshing {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
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
