//
//  ViewController.swift
//  Flicks
//
//  Created by Ali Mir on 9/13/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    var movies: [NSDictionary]?
    
    var endpoint = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchDataFromWeb()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.fetchDataFromWeb), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieDetail" {
            let movieDetailVC = segue.destination as! MovieDetailViewController
            movieDetailVC.movie = movies![tableView.indexPathForSelectedRow!.row]
        }
    }
    
    @objc func fetchDataFromWeb() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        var request = URLRequest(url: url!)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler:
        { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    self.movies = responseDictionary["results"] as? [NSDictionary]
                    self.tableView.reloadData()
                }
            }
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        });
        task.resume()
    }

}


extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flickCell", for: indexPath) as! MovieCell
        guard let movie = movies?[indexPath.row] else { return cell }
        let posterImageStr = "https://image.tmdb.org/t/p/w500" + (movie["poster_path"] as! String)
        let posterImageURL = URL(string: posterImageStr)!
        cell.titleLabel.text = movie["title"] as? String
        cell.overViewLabel.text = movie["overview"] as? String
        let releaseYear = (movie["release_date"] as! String).characters.split(separator: "-").map {String($0)}[0]
        cell.releaseYearLabel.text = releaseYear
        let avgRating = Double(movie["vote_average"] as! NSNumber)
        cell.averageVoteLabel.text = String(format: "%.1f", avgRating)
        cell.posterImageView.setImageWith(posterImageURL)
        
        return cell
    }
}
