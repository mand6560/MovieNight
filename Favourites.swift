//
//  Favourites+CoreDataClass.swift
//  MovieNight
//
//  Created by Steven Tran on 2021-04-16.
//
//

import Foundation
import CoreData
import UIKit

@objc(Favourites)
public class Favourites: NSManagedObject {
    
    // Create new entry in Favourites if it doesn't exist
    class func makeFavourites(actors: String, director: String, poster: Data, rated: String, released: String, runtime: String, synopsis: String, title: String, year: String, imdbID: String) -> Bool {
        let context = AppDelegate.viewContext
        if !Favourites.favouritesExists(with: title) {
            let favourites = Favourites(context: context)
            favourites.set(actors: actors, director: director, poster: poster, rated: rated, released: released, runtime: runtime, synopsis: synopsis, title: title, year: year, imdbID: imdbID)
            return true
        }
        return false
    }
    
    // Check if entry is already in favourites
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
    
    // Set new favourites entry
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
    
    // Get data about a movie/show by title
    class func getResultByTitle(title: String) -> Result?{
        let request: NSFetchRequest<Favourites> = Favourites.fetchRequest()
        request.predicate = NSPredicate(format: "title = %@", title)
        let context = AppDelegate.viewContext
        let favourites = try? context.fetch(request)
        if (favourites?.isEmpty)! {
            return nil
        } else {
            return Result(title: favourites![0].title!, year: favourites![0].year!, imdbID: favourites![0].imdbID!, mediaType: "", poster: UIImage(data: favourites![0].poster!))
        }
    }

}
