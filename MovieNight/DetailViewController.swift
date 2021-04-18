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
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var ratedLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    
    
    private var currentResult: Result?
    private var movieID: String?
    
    var movieTitle:  String? // done
    var year:        String? // done
    var rated:       String? // done
    var released:    String? // done
    var runtime:     String? // done
    var genre:       String?
    var director:    String? // done
    var writer:      String?
    var actors:      String? // done
    var synopsis:    String? // done
    var language:    String?
    var country:     String?
    var awards:      String?
    var poster:      String? // done
    var ratings:     Array<Any>?
    var imdbID:      String?
    
    let context = AppDelegate.viewContext
    // var watchlist: Watchlist?
    
    var urlString = "https://www.omdbapi.com/?apikey=638c2b56&i="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imdbButton.layer.cornerRadius = 10
        self.title = currentResult!.getTitle()
        movieImg.image = currentResult!.getPoster()
        movieID = currentResult!.getImdbID()
        imdbID = movieID

        getMovieData()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (Watchlist.watchlistExists(with: currentResult!.getTitle()) == true){
            watchlistButton.setTitle("Watchlisted", for: .normal)
            watchlistButton.isEnabled = false
        }
        if (Favourites.favouritesExists(with: currentResult!.getTitle()) == true){
            favouriteButton.setTitle("Favourited", for: .normal)
            favouriteButton.isEnabled = false
        }
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
                    actorsLabel.text = actors
                    runtimeLabel.text = runtime
                    ratedLabel.text = rated
                    yearLabel.text = year
                    releaseLabel.text = released
                    directorLabel.text = director
                    
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
//        self.movies!.set(actors: self.actors!, director: self.director!, poster: self.currentResult!.getPoster()!.pngData()!, rated: self.rated!, released: self.released!, runtime: self.runtime!, synopsis: self.synopsis!, title: self.movieTitle!, year: self.year!)
        let temp = Watchlist.makeWatchlist(actors: self.actors!, director: self.director!, poster: self.currentResult!.getPoster()!.pngData()!, rated: self.rated!, released: self.released!, runtime: self.runtime!, synopsis: self.synopsis!, title: self.movieTitle!, year: self.year!, imdbID: self.imdbID!)
        if (temp == true){
            watchlistButton.setTitle("Watchlisted", for: .normal)
            watchlistButton.isEnabled = false
        } else{
            print("Already exists")
        }
        do {
            try context.save()
            print("SAVED")
        } catch let error as NSError {
            print("\(error)")
        }
    }
    
    @IBAction func favouriteButtonClicked(_ sender: Any) {
        print("add to favourites")
        let temp = Favourites.makeFavourites(actors: self.actors!, director: self.director!, poster: self.currentResult!.getPoster()!.pngData()!, rated: self.rated!, released: self.released!, runtime: self.runtime!, synopsis: self.synopsis!, title: self.movieTitle!, year: self.year!, imdbID: self.imdbID!)
        if (temp == true){
            favouriteButton.setTitle("Favourited", for: .normal)
            favouriteButton.isEnabled = false
        }else{
            print("Already exists")
        }
        do {
            try context.save()
            print("SAVED")
        } catch let error as NSError {
            print("\(error)")
        }
        
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
