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
    private let mediaType: String?
    private var poster: UIImage?
    private var actors: String?
    private var director: String?
    private var rated: String?
    private var released: String?
    private var runtime: String?
    private var synopsis: String?
    
    
    
    init(title: String, year: String, imdbID: String, mediaType: String, poster: UIImage?){
        self.title = title
        self.year = year
        self.imdbID = imdbID
        self.mediaType = mediaType
        self.poster = poster
    }
    
    init (actors: String, director: String, poster: Data, rated: String, released: String, runtime: String, synopsis: String, title: String, year: String, imdbID: String) {
        self.actors = actors
        self.director = director
        self.poster = UIImage(data: poster)
        self.rated = rated
        self.released = released
        self.runtime = runtime
        self.synopsis = synopsis
        self.title = title
        self.year = year
        self.imdbID = imdbID
        self.mediaType = ""
    }
    
    func getActor() -> String{
        return self.actors!
    }
    
    func getDirecter() -> String{
        return self.director!
    }
    
    func getRated() -> String{
        return self.rated!
    }
    
    func getReleased() -> String {
        return self.released!
    }
    
    func getRuntime() -> String{
        return self.runtime!
    }
    
    func getSynopsis() -> String {
        return self.synopsis!
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
    func getMediaType() -> String?{
        return self.mediaType
    }
    
    func getPoster() -> UIImage?{
        return self.poster
    }
    
    func getPosterData() -> Data{
        return (self.poster?.pngData())!
    }
    
    func setPoster(img:UIImage?){
        self.poster = img
    }
    
    
}
