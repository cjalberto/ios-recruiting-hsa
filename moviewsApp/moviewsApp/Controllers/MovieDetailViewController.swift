//
//  MovieDetailViewController.swift
//  moviewsApp
//
//  Created by carlos jaramillo on 8/31/18.
//  Copyright © 2018 carlos jaramillo. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var likeButton: UIImageView!
    @IBOutlet weak var posterMovieImage: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var nameMovieLabel: UILabel!
    @IBOutlet weak var scroll: UIScrollView!
    
    var movie : Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        self.loadDataView()
    }
    
    func loadDataView(){
        guard   let path = self.movie?.posterPath ,
                let overview = self.movie?.overview ,
                let genres = self.movie?.genreIds ,
                let year = self.movie?.releaseDate ,
                let name = self.movie?.title else {
                
            return
        }
        
        self.posterMovieImage.loadPicture(of: "\(baseURLS.posters.rawValue)\(path)")
        
        self.overviewLabel.text = overview
        self.overviewLabel.numberOfLines = 0
        self.overviewLabel.lineBreakMode = .byWordWrapping
        self.overviewLabel.preferredMaxLayoutWidth = self.scroll.frame.width
        
        if Movie.favorites.filter({$0.id == self.movie?.id}).count > 0{
            self.likeButton.image = #imageLiteral(resourceName: "favorite").withRenderingMode(.alwaysTemplate)
            self.likeButton.tintColor = UIColor(named: "principalColor")
        }
        
        self.genresLabel.text = self.generateGenreText(genreIds: genres)
        
        self.yearLabel.text = year.split(separator: "-")[0].description
        
        self.nameMovieLabel.text = name
        
        self.title = name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.scroll.layoutIfNeeded()
        self.scroll.contentSize.height = self.overviewLabel.frame.maxY + 10
    }
    
    func generateGenreText(genreIds : [Int]) -> String{
        if Genre.genres.isEmpty{
            return ""
        }
        var text = ""
        genreIds.forEach { (id) in
            let array = Genre.genres.filter({$0.id == id})
            if array.isEmpty == false{
                text = text + array[0].name! + (id == genreIds.last! ? "" : ",")
            }
        }
        return text
    }

}