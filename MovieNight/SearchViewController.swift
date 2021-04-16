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
    
    var resultTemp = Result(title: "Spongebob Squarepants", year: "1999", imdbID: "1f4tgg", mediaType: "series", poster: UIImage(systemName: "doc")!)
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
        fetchSearchResults(searchQuery: searchBar.text!)
    }
    
    func fetchSearchResults(searchQuery: String) {
//        var temp = searchQuery
        print(urlString + searchQuery)
        let searchQuery = searchQuery.replacingOccurrences(of: " ", with: "+")
        let url: NSURL = NSURL(string: urlString + searchQuery)!
        let request: URLRequest=URLRequest(url: url as URL)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        var result: NSString
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
//            print("WORKING")
            self.dataStore = data! as NSData
            result = NSString(data: self.dataStore as Data, encoding: String.Encoding.utf8.rawValue)!
//            print(" the JSON file content is ")
//            print(results!)
//            print(response!)
//            print("")
//            self.parseXML()
        })
        task.resume()
        let resultsString: String = result as String
        let jsonData = resultsString.data(using: .utf8)!
        let decoder = JSONDecoder()
        var resultDict = [[String:String]]()
        let movie = try decoder.decode(resultDict,from: jsonData)
        print(jsonData)
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
