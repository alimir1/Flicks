//
//  Movie.swift
//  Flicks
//
//  Created by Ali Mir on 9/14/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import Foundation

class Movie: NSObject {
    private(set)var avgRating: Double?
    private(set)var title: String?
    private(set)var overview: String?
    private(set)var posterImageURLMedium: URL?
    private(set)var posterImageURLHigh: URL?
    private(set)var posterImageURLLow: URL?
    private(set)var backdropImageURLMedium: URL?
    private(set)var backdropImageURLHigh: URL?
    private(set)var backdropImageURLLow: URL?
    private(set)var releaseYear: String?
    
    init(dictionary: NSDictionary) {
        let posterImagePath = dictionary["poster_path"] as? String
        let backdropImagePath = dictionary["backdrop_path"] as? String
        let title = dictionary["title"] as? String
        let overview = dictionary["overview"] as? String
        let releaseYear = (dictionary["release_date"] as? String)?.characters.split(separator: "-").map {String($0)}[0]
        let avgRating = dictionary["vote_average"] as? Double
        self.title = title
        self.overview = overview
        self.releaseYear = releaseYear
        self.avgRating = avgRating
        
        if let backdropPath = backdropImagePath {
            self.backdropImageURLMedium = URL(string: TheMovieDBApi.imageBaseStr + "w500" + backdropPath)
            self.backdropImageURLHigh = URL(string: TheMovieDBApi.imageBaseStr + "original" + backdropPath)
            self.backdropImageURLLow = URL(string: TheMovieDBApi.imageBaseStr + "w45" + backdropPath)
        }
        
        if let posterImagePath = posterImagePath {
            self.posterImageURLMedium = URL(string: TheMovieDBApi.imageBaseStr + "w500" + posterImagePath)
            self.posterImageURLHigh = URL(string: TheMovieDBApi.imageBaseStr + "original" + posterImagePath)
            self.posterImageURLLow = URL(string: TheMovieDBApi.imageBaseStr + "w45" + posterImagePath)
        }
        
    }
    
    class func movies(with dictionaries: [NSDictionary]) -> [Movie] {
        return dictionaries.map {Movie(dictionary: $0)}
    }
    
}
