//
//  SearchViewController.swift
//  MovieNight
//
//  Created by Patrick Mandarino on 2021-04-12.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    
    // MARK: - Global Variable
    var urlString = "https://www.omdbapi.com/?apikey=638c2b56&s="
    var mediaList = [Result]()
    
    var cellIdentifier = "search-cell"
    var dataStore = NSData()
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        searchBar.delegate = self
        self.title = "Search"
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! DetailViewController
        let selectedResultCell = sender as! UITableViewCell
        let indexPath = myTableView.indexPath(for: selectedResultCell)
        let selectedResult = mediaList[indexPath!.row]
        detailVC.setCurrentResult(to: selectedResult)
    }
    
    // MARK: - TableView delgates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifier)
        }
        
        if let img = mediaList[indexPath.row].getPoster(){
            cell?.imageView?.image = img
        } else {
            cell?.imageView?.image = UIImage(systemName: "Search")
        }
        cell?.textLabel?.text = mediaList[indexPath.row].getTitle()
        
        return cell! //MARK: Change Later
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        mediaList.removeAll()
        fetchSearchResults(searchQuery: searchBar.text!)
    }
    
    func fetchSearchResults(searchQuery: String) {
        do {
            let searchQuery = searchQuery.replacingOccurrences(of: " ", with: "+")
            if let url = URL(string: urlString + searchQuery) {
                //print(url)
                let data = try Data(contentsOf: url)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    //let response = object["Response"] as! String
                    let searchResultsObject = object["Search"] as! Array<Any>
                    //print(response)
                    //print(search)
                    for resultObject in searchResultsObject {
                        if let result = resultObject as? [String: Any] {
                            let newResult = Result(title: result["Title"] as! String, year: result["Year"] as! String, imdbID: result["imdbID"] as! String, mediaType: result["Type"] as! String, poster: nil)
                            
                            let imageURLString = result["Poster"] as! String
                            var posterImage: UIImage?
                            
                            if (imageURLString == "N/A") {
                                posterImage = UIImage(systemName: "photo")
                            } else {
                                let imageURL = URL(string: result["Poster"] as! String)!
                                let imageData = try Data(contentsOf: imageURL)
                                posterImage = UIImage(data: imageData)
                            }
                            
                            newResult.setPoster(img: posterImage)
                            mediaList.append(newResult)
                        }
                    }
                } else {
                print("JSON is invalid")
                }
            } else {
                fatalError()
            }
        } catch {
            fatalError()
        }
        myTableView.reloadData()
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
