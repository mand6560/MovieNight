//
//  Result.swift
//  MovieNight
//
//  Created by Steven Tran on 2021-04-12.
//

import Foundation
import UIKit

class Result {
    private let title: String
    private let year: String
    private let imdbID: String
    private let mediaType: String
    private var poster: UIImage?
    
    init(title: String, year: String, imdbID: String, mediaType: String, poster: UIImage?){
        self.title = title
        self.year = year
        self.imdbID = imdbID
        self.mediaType = mediaType
        self.poster = poster
    }
    
    func getTitle() -> String{
        return self.title
    }
    
    func getYear() -> String{
        return self.year
    }
    
    func getImdbID() -> String{
        return self.imdbID
    }
    func getMediaType() -> String{
        return self.mediaType
    }
    
    func getPoster() -> UIImage?{
        return self.poster
    }
    
    func setPoster(img:UIImage){
        self.poster = img
    }
    
    
}
