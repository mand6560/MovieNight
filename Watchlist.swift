//
//  Watchlist+CoreDataClass.swift
//  MovieNight
//
//  Created by Steven Tran on 2021-04-16.
//
//

import Foundation
import CoreData
import UIKit

@objc(Watchlist)
public class Watchlist: NSManagedObject {
    
    // Create new entry for Watchlist if it doesn't already exist
    class func makeWatchlist(actors: String, director: String, poster: Data, rated: String, released: String, runtime: String, synopsis: String, title: String, year: String, imdbID: String) -> Bool {
        let context = AppDelegate.viewContext
        if !Watchlist.watchlistExists(with: title) {
            let watchlist = Watchlist(context: context)
            watchlist.set(actors: actors, director: director, poster: poster, rated: rated, released: released, runtime: runtime, synopsis: synopsis, title: title, year: year, imdbID: imdbID)
            return true
        }
        return false
    }
    
    // Check if entry already exists in Watchlist
    class func watchlistExists(with title: String) -> Bool {
        let request: NSFetchRequest<Watchlist> = Watchlist.fetchRequest()
        request.predicate = NSPredicate(format: "title = %@", title)
        let context = AppDelegate.viewContext
        let watchlist = try? context.fetch(request)
        if (watchlist?.isEmpty)! {
            return false
        } else {
            return true
        }
    }
    
    // Set new entry in Watchlist
    func set(actors: String, director: String, poster: Data, rated: String, released: String, runtime: String, synopsis: String, title: String, year: String, imdbID: String) {
        self.actors = actors
        self.director = director
        self.poster = poster
        self.rated = rated
        self.released = released
        self.runtime = runtime
        self.synopsis = synopsis
        self.title = title
        self.year = year
        self.imdbID = imdbID
    }
    
    // Get the information about a movie/show by its title
    class func getResultByTitle(title: String) -> Result?{
        let request: NSFetchRequest<Watchlist> = Watchlist.fetchRequest()
        request.predicate = NSPredicate(format: "title = %@", title)
        let context = AppDelegate.viewContext
        let watchlist = try? context.fetch(request)
        if (watchlist?.isEmpty)! {
            return nil
        } else {
            return Result(title: watchlist![0].title!, year: watchlist![0].year!, imdbID: watchlist![0].imdbID!, mediaType: "", poster: UIImage(data: watchlist![0].poster!))
        }
    }
}
