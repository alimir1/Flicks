//
//  MoviesTableViewDataSource.swift
//  Flicks
//
//  Created by Ali Mir on 9/15/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit

class MoviesTableViewDataSource: NSObject, UITableViewDataSource {
    
    var movies = [Movie]()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flickCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        cell.titleLabel.text = movie.title
        cell.overViewLabel.text = movie.overview
        cell.releaseYearLabel.text = movie.releaseYear
        cell.averageVoteLabel.text = String(format: "%.1f", movie.avgRating ?? 0)
        if let posterImageURL = movie.posterImageURLMedium {
            cell.posterImageView.setImageWith(posterImageURL, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
        } else {
            cell.posterImageView.image = #imageLiteral(resourceName: "placeholderImage")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
}
