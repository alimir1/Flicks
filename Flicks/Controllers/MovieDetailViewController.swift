//
//  MovieDetailViewController.swift
//  Flicks
//
//  Created by Ali Mir on 9/13/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet var backdropImageView: UIImageView!
    @IBOutlet var overViewLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: contentView.frame.origin.y + contentView.frame.height)
        self.navigationItem.title = movie.title
        overViewLabel.text = movie.overview
        overViewLabel.sizeToFit()
        if let smallImageURL = movie.backdropImageURLLow, let largeImageURL = movie.backdropImageURLHigh {
            setImage(with: smallImageURL, largeImageURL: largeImageURL)
        } else {
            backdropImageView.image = #imageLiteral(resourceName: "placeholderImage")
        }
    }
    
    func setImage(with smallImageURL: URL, largeImageURL: URL) {
        let smallImageRequest = URLRequest(url: smallImageURL)
        self.backdropImageView.setImageWith(
            smallImageRequest,
            placeholderImage: #imageLiteral(resourceName: "placeholderImage"),
            success: {
                (_, _, smallImage) in
                self.backdropImageView.alpha = 0.0
                self.backdropImageView.image = smallImage
                UIView.animate(
                    withDuration: 0.3,
                    animations: {self.backdropImageView.alpha = 1.0})
                { _ in self.backdropImageView.setImageWith(largeImageURL) }
        },
            failure: { _ in self.backdropImageView.image = #imageLiteral(resourceName: "placeholderImage") })
    }
    
}
