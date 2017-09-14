//
//  MovieCell.swift
//  Flicks
//
//  Created by Ali Mir on 9/13/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var overViewLabel: UILabel!
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var releaseYearLabel: UILabel!
    @IBOutlet var averageVoteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
