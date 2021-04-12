//
//  SearchViewController.swift
//  MovieNight
//
//  Created by Patrick Mandarino on 2021-04-12.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    
    // MARK: - Global Variable
    private final var apiKey = "638c2b56"
    var urlString = "http://www.omdbapi.com/?s="
    
    var resultTemp = Result(title: "Spongebob Squarepants", year: "1999", imdbID: "1f4tgg", mediaType: "series", poster: UIImage(systemName: "doc")!)
    var mediaList = [Result]()
    
    var cellIdentifier = "search-cell"
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        self.title = "Search"
        mediaList.append(resultTemp)
        
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
        }
        cell?.textLabel?.text = mediaList[indexPath.row].getTitle()
        
        return cell! //MARK: Change Later
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
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
