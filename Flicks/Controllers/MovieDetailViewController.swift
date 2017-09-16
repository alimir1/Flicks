//
//  MovieDetailViewController.swift
//  Flicks
//
//  Created by Ali Mir on 9/13/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var overViewLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: contentView.frame.origin.y + contentView.frame.height)
        self.navigationItem.title = title
        overViewLabel.text = movie.overview
        overViewLabel.sizeToFit()
        if let smallImageURL = movie.posterImageURLLow, let largeImageURL = movie.posterImageURLHigh {
            setImage(with: smallImageURL, largeImageURL: largeImageURL)
        } else {
            posterImageView.image = #imageLiteral(resourceName: "placeholderImage")
        }
    }
    
    func setImage(with smallImageURL: URL, largeImageURL: URL) {
        let smallImageRequest = URLRequest(url: smallImageURL)
        
        self.posterImageView.setImageWith(
            smallImageRequest,
            placeholderImage: #imageLiteral(resourceName: "placeholderImage"),
            success: {
                (_, _, smallImage) in
                self.posterImageView.alpha = 0.0
                self.posterImageView.image = smallImage
                
                UIView.animate(
                    withDuration: 0.3,
                    animations: {self.posterImageView.alpha = 1.0})
                { _ in self.posterImageView.setImageWith(largeImageURL) }
        },
            failure: { _ in self.posterImageView.image = #imageLiteral(resourceName: "placeholderImage") })
    }
    
}
