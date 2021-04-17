//
//  Watchlist+CoreDataProperties.swift
//  MovieNight
//
//  Created by Steven Tran on 2021-04-16.
//
//

import Foundation
import CoreData


extension Watchlist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Watchlist> {
        return NSFetchRequest<Watchlist>(entityName: "Watchlist")
    }

    @NSManaged public var actors: String?
    @NSManaged public var director: String?
    @NSManaged public var imdbID: String?
    @NSManaged public var poster: Data?
    @NSManaged public var rated: String?
    @NSManaged public var released: String?
    @NSManaged public var runtime: String?
    @NSManaged public var synopsis: String?
    @NSManaged public var title: String?
    @NSManaged public var year: String?

}

extension Watchlist : Identifiable {

}
