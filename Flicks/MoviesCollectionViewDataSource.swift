//
//  MoviesCollectionViewDataSource.swift
//  Flicks
//
//  Created by Ali Mir on 9/15/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit

class MoviesCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var movies = [Movie]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCollectionCell", for: indexPath) as! MovieCollectionCell
        if let posterImageURL = movies[indexPath.row].posterImageURLMedium {
            cell.posterImageView.setImageWith(posterImageURL)
        } else {
            // FIXME: - Set placeholder
        }
        return cell
    }
}
