//
//  TheMovieDbApi.swift
//  Flicks
//
//  Created by Ali Mir on 9/14/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import Foundation

enum TheMovieDBErrors: Error {
    case networkFail(description: String)
    case jsonSerializationFail
    case dataNotReceived
    case castFail
    case internalError
    case unknown
}

extension TheMovieDBErrors: LocalizedError {
    public var errorDescription: String? {
        let defaultMessage = "Unknown error! Please try again later."
        let internalErrorMessage = "Something weird happened on our side. Please contact our support team and we'll do our best to do better next time!"
        switch self {
        case .networkFail(let localizedDescription):
            print(localizedDescription)
            return localizedDescription
        case .jsonSerializationFail:
            return internalErrorMessage
        case .dataNotReceived:
            return internalErrorMessage
        case .castFail:
            return internalErrorMessage
        case .internalError:
            return internalErrorMessage
        case .unknown:
            return defaultMessage
        }
    }
}


@objc protocol TheMovieDBDelegate: NSObjectProtocol {
    func theMovieDB(didFinishUpdatingMovies movies: [Movie])
    @objc optional func theMovieDB(didFailWithError error: Error)
}

class TheMovieDBApi: NSObject {
    static let apiKey: String = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    static let posterImageBaseStr: String = "https://image.tmdb.org/t/p/"
    
    var delegate: TheMovieDBDelegate?
    var endpoint: String
    
    init(endpoint: String) {
        self.endpoint = endpoint
    }
    
    var urlRequest: URLRequest {
        get {
            let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(TheMovieDBApi.apiKey)")
            return URLRequest(url: url!)
        }
        
        set {}
    }
    
    func startUpdatingMovies() {
        
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: urlRequest, completionHandler:
        { (data, response, error) in
            
            
            guard error == nil else {
                self.delegate?.theMovieDB?(didFailWithError: TheMovieDBErrors.networkFail(description: error!.localizedDescription))
                print("TheMovieDBApi: \(error!.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                self.delegate?.theMovieDB?(didFailWithError: TheMovieDBErrors.unknown)
                print("TheMovieDBApi: Unknown error. Could not get response!")
                return
            }
            
            guard response.statusCode == 200 else {
                self.delegate?.theMovieDB?(didFailWithError: TheMovieDBErrors.internalError)
                print("TheMovieDBApi: Response code was either 401 or 404.")
                return
            }
            
            guard let data = data else {
                self.delegate?.theMovieDB?(didFailWithError: TheMovieDBErrors.dataNotReceived)
                print("TheMovieDBApi: Could not get data!")
                return
            }
            
            do {
                let movies = try self.movieObjects(with: data)
                self.delegate?.theMovieDB(didFinishUpdatingMovies: movies)
            } catch (let error) {
                self.delegate?.theMovieDB?(didFailWithError: error)
                print("TheMovieDBApi: Some problem occurred during JSON serialization.")
                return
            }
            
        });
        task.resume()
    }
    
    func movieObjects(with data: Data) throws -> [Movie] {
        do {
            
            guard let responseDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                throw TheMovieDBErrors.castFail
            }
            
            guard let movieDictionaries = responseDictionary["results"] as? [NSDictionary] else {
                print("TheMovieDBApi: Movie dictionary not found.")
                throw TheMovieDBErrors.unknown
            }
            
            return Movie.movies(with: movieDictionaries)
            
        } catch (let error) {
            print("TheMovieDBApi: \(error.localizedDescription)")
            throw error
        }
    }
}
