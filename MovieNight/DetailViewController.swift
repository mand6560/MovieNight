//
//  DetailViewController.swift
//  MovieNight
//
//  Created by Steven Tran on 2021-04-16.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imdbButton: UIButton!
    @IBOutlet weak var watchlistButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    
    
    private var currentResult: Result?
    private var movieID: String?
    
    var movieTitle:  String? //
    var year:        String? //
    var rated:       String? //
    var released:    String? //
    var runtime:     String? // maybe
    var genre:       String?
    var director:    String? //
    var writer:      String?
    var actors:      String? //
    var synopsis:    String? //
    var language:    String?
    var country:     String?
    var awards:      String?
    var poster:      String? //
    var ratings:     Array<Any>?
    
    
    
    var urlString = "https://www.omdbapi.com/?apikey=638c2b56&i="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imdbButton.layer.cornerRadius = 5
        self.title = currentResult!.getTitle()
        movieImg.image = currentResult!.getPoster()
        movieID = currentResult!.getImdbID()
        
        getMovieData()

        // Do any additional setup after loading the view.
    }
    
    func setCurrentResult(to result: Result){
        self.currentResult = result
    }
    
    func getMovieData() {
        do {
            if let url = URL(string: urlString + movieID!) {
                //print(url)
                let data = try Data(contentsOf: url)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    movieTitle = (object["Title"] as! String)
                    year = (object["Year"] as! String)
                    rated = (object["Rated"] as! String)
                    released = (object["Released"] as! String)
                    runtime = (object["Runtime"] as! String)
                    genre = (object["Genre"] as! String)
                    director = (object["Director"] as! String)
                    writer = (object["Writer"] as! String)
                    actors = (object["Actors"] as! String)
                    synopsis = (object["Plot"] as! String)
                    language = (object["Language"] as! String)
                    country = (object["Country"] as! String)
                    awards = (object["Awards"] as! String)
                    poster = (object["Poster"] as! String)
                    ratings = (object["Ratings"] as! Array<Any>)
                    descriptionLabel.text = synopsis
                } else {
                    print("JSON is invalid")
                }
            } else {
                fatalError()
            }
        } catch {
            fatalError()
        }
    }
    
    @IBAction func watchlistButtonClicked(_ sender: Any) {
        print("add to watchlist")
    }
    
    @IBAction func favouriteButtonClicked(_ sender: Any) {
        print("add to favourites")
    }
    
    @IBAction func imdbButtonClicked(_ sender: Any) {
        print("Navigate to IMDB")
        let url = URL(string: "https://www.imdb.com/title/" + movieID!)!
        UIApplication.shared.open(url)
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
