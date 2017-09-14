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
    
    var movie: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        let title = movie["title"] as? String
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: contentView.frame.origin.y + contentView.frame.height)
        self.navigationItem.title = title
        overViewLabel.text = movie["overview"] as? String
        overViewLabel.sizeToFit()
        let posterImageStr = "https://image.tmdb.org/t/p/original" + (movie["poster_path"] as! String)
        let posterImageURL = URL(string: posterImageStr)!
        posterImageView.setImageWith(posterImageURL)
        
    }
}
