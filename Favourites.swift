//
//  Favourites+CoreDataClass.swift
//  MovieNight
//
//  Created by Steven Tran on 2021-04-16.
//
//

import Foundation
import CoreData

@objc(Favourites)
public class Favourites: NSManagedObject {
    
    class func makeFavourites(actors: String, director: String, poster: Data, rated: String, released: String, runtime: String, synopsis: String, title: String, year: String) -> Bool {
        let context = AppDelegate.viewContext
        if !Favourites.favouritesExists(with: title) {
            let favourites = Favourites(context: context)
            favourites.set(actors: actors, director: director, poster: poster, rated: rated, released: released, runtime: runtime, synopsis: synopsis, title: title, year: year)
            return true
        }
        return false
    }
    
    class func favouritesExists(with title: String) -> Bool {
        let request: NSFetchRequest<Favourites> = Favourites.fetchRequest()
        request.predicate = NSPredicate(format: "title = %@", title)
        let context = AppDelegate.viewContext
        let favourites = try? context.fetch(request)
        if (favourites?.isEmpty)! {
            return false
        } else {
            return true
        }
    }

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
