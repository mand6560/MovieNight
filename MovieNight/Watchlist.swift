//
//  Watchlist.swift
//  MovieNight
//
//  Created by Patrick Mandarino on 2021-04-16.
//

import UIKit
import CoreData

class Watchlist: NSManagedObject {
    func set(actors: String, director: String, poster: Data, rated: String, released: String, runtime: String, synopsis: String, title: String, year: String) {
        self.actors = actors
        self.director = director
        self.poster = poster
        self.rated = rated
        self.released = released
        self.runtime = runtime
        self.synopsis = synopsis
        self.title = title
        self.year = year
    }
}
