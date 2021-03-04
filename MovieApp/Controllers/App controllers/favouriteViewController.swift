//
//  favouriteViewController.swift
//  MovieApp
//
//  Created by Ehab Osama on 2/15/21.
//

import UIKit
import FirebaseAuth

class favouriteViewController: UIViewController {
    var refreshControl = UIRefreshControl()
    
    private let noFavouritesLabel:UILabel = {
       let label = UILabel ()
        label.text = "No Movies on Favourites!"
        label.textAlignment = .center
        label.textColor = .systemPink
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    var favouriteMoviesArray = [Movie]()
    
    var show_movie_model:MovieIDStruct? {
        didSet {

            showMovieVC()
        }
    }
    
    func showMovieVC() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let movieVC = storyBoard.instantiateViewController(identifier: "MovieViewController") as! MovieViewController
        movieVC.modalPresentationStyle = .fullScreen
        movieVC.movie_model = show_movie_model
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(movieVC, animated: true)
        }
    }

    @IBOutlet weak var table_view: UITableView!

    @objc func refresh_func()  {
        print("movie count...\(favouriteMoviesArray.count)")
        self.viewDidLoad()
        refreshControl.endRefreshing()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh_func), for: .valueChanged)
        table_view.addSubview(refreshControl)
        view.addSubview(noFavouritesLabel)
        //table_view.isHidden = true
        
        dwonloadFavouriteMovies()
        title = "Your Favourites"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        table_view.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        table_view.delegate = self
        table_view.dataSource = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noFavouritesLabel.frame = view.bounds
    }
    func dwonloadFavouriteMovies()  {
        print("dkhal f download favourite function")
        if let email = Auth.auth().currentUser?.email?.SafeDB() {
            DatabaseManager.shared.downloadFavouriteMovies(email: email) { (succed) in
                switch succed {
                case .success(let favouriteMovies) :
                    print("your favourite movies .. \(favouriteMovies)")
                    self.favouriteMoviesArray = favouriteMovies
                    print("your favourites count .. \(self.favouriteMoviesArray.count)")
                    
                    DispatchQueue.main.async {
                        //self.table_view.isHidden = false
                        //self.noFavouritesLabel.isHidden = true
                        self.table_view.reloadData()
                    }
                case .failure(let error) :
                    //self.noFavouritesLabel.isHidden = false
                    //self.table_view.isHidden = true
                    print("error on download favourite movies in SearchVC ... \(error)")
                }
            }
        }
    }
    
    
    func search_movie_id(id:String)  {
        print(" id .... \(id)")
        let task = URLSession.shared.dataTask(with: URL(string: "http://www.omdbapi.com/?i=\(id)&apikey=4dc10e06")!) { (data, response, error) in
            
            guard let data = data , error == nil else {
                print("error in getting data \(String(describing: error))")
                return
            }
            
            //convert
            var result : MovieIDStruct?
            do {
                
                result = try JSONDecoder().decode(MovieIDStruct.self, from: data)
            }
            catch {
                print("error in catch")
                
            }
            guard let finalResult = result else {
                return
            }
            
            //update our movies array
            let newMovie = finalResult
 
            self.show_movie_model = newMovie
        }
        print("task resume")
        task.resume()
        
    }

}

extension favouriteViewController:UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteMoviesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        cell.delegate = self
        cell.configure(model: favouriteMoviesArray[indexPath.row], favourite: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = favouriteMoviesArray[indexPath.row]
        print("id of seleected model .... \(model.imdbID)")
        search_movie_id(id: model.imdbID)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 370
    }
    
}

extension favouriteViewController:MovieCellDelegate {
    
    func SaveButtonPressed(model: Movie) {
        
        DatabaseManager.shared.deleteFavouriteMovie(email:(Auth.auth().currentUser?.email)!,id: model.imdbID) { [self] (Succeed) in
            if Succeed {
                for i in (0..<favouriteMoviesArray.count) {
                    if  favouriteMoviesArray[i].imdbID == model.imdbID {
                        favouriteMoviesArray.remove(at: i)
                        break
                    }
                }
                DispatchQueue.main.async {
                    self.table_view.reloadData()
                }
                return
            }
    }
    }

    
    
}
