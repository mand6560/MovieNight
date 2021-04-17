//
//  WatchListViewController.swift
//  MovieNight
//
//  Created by Patrick Mandarino on 2021-04-12.
//

import UIKit
import CoreData

class WatchListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var watchListTableView: UITableView!
    private let cellIdentifier: String = "watchlist-cell"
    
    //private var watchList: [Any] = []
    //private var watchList: [String] = ["Movie 1", "Movie 2", "Movie 3"]
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Watchlist"
        watchListTableView.delegate = self
        watchListTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initializeFetchedResultsController()
        watchListTableView.reloadData()
    }
    
    // MARK: - UITableView Delegate
    
    func numberOfSectionsInTableView(sender: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Remove the highlight when row is selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "watchlist-cell")
        let obj = fetchedResultsController.object(at: indexPath) as! Watchlist
        cell?.textLabel?.text = obj.title
        cell?.imageView?.image = UIImage(data: obj.poster!)
        // print("Title of thing is: \(obj.title)")
        print("INSERT")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = AppDelegate.viewContext
        switch editingStyle {
        case .delete:
            let movies = fetchedResultsController.object(at: indexPath) as! Watchlist
            context.delete(movies)
            do {
                try context.save()
            } catch let error as NSError {
                print("Error saving context after delete:\(error.localizedDescription)")
            }
        default:break
            
        }
    }
    
    // MARK: - FetchedResult
    
    func initializeFetchedResultsController() {
        //  formulate a request
        let request : NSFetchRequest<Watchlist> = Watchlist.fetchRequest()
        let fetchSort = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [fetchSort]
        
        // Get the context
        let context = AppDelegate.viewContext
        
        //make a fetch request, the result is returned to the var
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
            as? NSFetchedResultsController<NSFetchRequestResult>
        
        do {
            let count = try context.count(for: request)
            print("Count is: \(count)")
        } catch {
            print(error.localizedDescription)
        }
        
        // When the database changes, the delegate will be notified.
        // We can reload the UITableView to reflect the change.
        fetchedResultsController.delegate = self
        
        do {
            // make the fetch
            try fetchedResultsController.performFetch()
            print()
            print("FETCH")
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    // MARK: - FetchedResultControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        watchListTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        watchListTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            watchListTableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        case .delete:
            watchListTableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            watchListTableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            watchListTableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
}
