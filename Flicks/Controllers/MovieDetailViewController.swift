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
        if let posterImageURL = movie.posterImageURLHigh {
            posterImageView.setImageWith(posterImageURL)
        } else {
            // FIXME: - set placeholder here
        }
        
    }
}
