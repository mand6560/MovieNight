//
//  FavouritesViewController.swift
//  MovieNight
//
//  Created by Patrick Mandarino on 2021-04-12.
//

import UIKit
import CoreData

class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    @IBOutlet weak var favouriteListTableView: UITableView!
    let context = AppDelegate.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Favourites"
        favouriteListTableView.delegate = self
        favouriteListTableView.dataSource = self
    }
    
    // Update the table view data
    override func viewDidAppear(_ animated: Bool) {
        initializeFetchedResultsController()
        favouriteListTableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "favourites-cell")
        let obj = fetchedResultsController.object(at: indexPath) as! Favourites
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
            let movies = fetchedResultsController.object(at: indexPath) as! Favourites
            context.delete(movies)
            do {
                try context.save()
            } catch let error as NSError {
                print("Error saving context after delete:\(error.localizedDescription)")
            }
        default:break
            
        }
    }
    
    // Prepare for segue to detail view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! DetailViewController
        let selectedResultCell = sender as! UITableViewCell
        let indexPath = favouriteListTableView.indexPath(for: selectedResultCell)
        let selectedResult = fetchedResultsController.object(at: indexPath!) as! Favourites
        
        detailVC.setCurrentResult(to: Favourites.getResultByTitle(title: selectedResult.title!)!, sender: 2)
    }
    
    // MARK: - FetchedResult
    
    // Initialize the fetch of core data
    func initializeFetchedResultsController() {
        //  formulate a request
        let request : NSFetchRequest<Favourites> = Favourites.fetchRequest()
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
        favouriteListTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        favouriteListTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            favouriteListTableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        case .delete:
            favouriteListTableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            favouriteListTableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            favouriteListTableView.deleteRows(at: [indexPath!], with: .automatic)
            print("deleted!")
        default:
            break
        }
    }
    
    @IBAction func unwindToFavourites(unwindSegue: UIStoryboardSegue){
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
