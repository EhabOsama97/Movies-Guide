//
//  SearchViewController.swift
//  MovieApp
//
//  Created by Ehab Osama on 2/14/21.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class SearchViewController: UIViewController {

    let snipper = JGProgressHUD(style: .dark)
    @IBOutlet weak var searchBarr: UISearchBar!
    
    @IBOutlet weak var tableVieww: UITableView!
    
    var favourite_movies_array = [Movie]()
    
    //var movies = [Movie] ()
    var movies_result = [Movie]()
    
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
            self.snipper.dismiss()
            self.navigationController?.pushViewController(movieVC, animated: true)
        }
    }
    
    func dwonloadFavouriteMovies()  {
        print("dkhal f download favourite function")
        if let email = Auth.auth().currentUser?.email?.SafeDB() {
            DatabaseManager.shared.downloadFavouriteMovies(email: email) { (succed) in
                switch succed {
                case .success(let favouriteMovies) :
                    print("your favourite movies .. \(favouriteMovies)")
                    self.favourite_movies_array = favouriteMovies
                case .failure(let error) :
                    print("error on download favourite movies in SearchVC ... \(error)")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        print("hydkhol fl function")
        dwonloadFavouriteMovies()
        tableVieww.delegate = self
        tableVieww.dataSource = self
        searchBarr.delegate = self
        tableVieww.showsVerticalScrollIndicator = false
        searchBarr.becomeFirstResponder()
        tableVieww.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
    }
    
}


//MARK: - api functions
extension SearchViewController {
    
    func SearchMovies_withName(query:String) {
        print("text of query .... \(query)")
        let newQuery = query.replacingOccurrences(of: " ", with: "%20")
        movies_result.removeAll()
        let task = URLSession.shared.dataTask(with: URL(string: "http://www.omdbapi.com/?i=tt3896198&apikey=4dc10e06&s=\(newQuery)&type=movie#")!) { (data, response, error) in
            
            guard let data = data , error == nil else {
                print("error in getting data \(String(describing: error))")
                return
            }
            
            //convert
            var result : MovieResult?
            do {
                
                result = try JSONDecoder().decode(MovieResult.self, from: data)
            }
            catch {
                print("error in catch")
                
            }
            guard let finalResult = result else {
                DispatchQueue.main.async {
                    self.movies_result.shuffle()
                    self.tableVieww.reloadData()
                }
                
                return
            }
            
            //update our movies array
            let newMovies = finalResult.Search
            //self.movies.append(contentsOf: newMovies)
            self.movies_result = newMovies
            //Refresh tableview
            DispatchQueue.main.async {
                self.movies_result.shuffle()
                self.tableVieww.reloadData()
            }
        }
        
        task.resume()
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
    
    func SearchSeries_withName(query:String) {
        print("text of query .... \(query)")
        let newQuery = query.replacingOccurrences(of: " ", with: "%20")
        let task = URLSession.shared.dataTask(with: URL(string: "http://www.omdbapi.com/?i=tt3896198&apikey=4dc10e06&s=\(newQuery)&type=series#")!) { (data, response, error) in
            
            guard let data = data , error == nil else {
                print("error in getting data \(String(describing: error))")
                return
            }
            
            //convert
            var result : MovieResult?
            do {
                
                result = try JSONDecoder().decode(MovieResult.self, from: data)
            }
            catch {
                print("error in catch")
                
            }
            guard let finalResult = result else {
                DispatchQueue.main.async {
                    self.movies_result.shuffle()
                    self.tableVieww.reloadData()
                }
                
                return
            }
            
            //update our movies array
            let newMovies = finalResult.Search
            //self.movies.append(contentsOf: newMovies)
            let allMovies = newMovies + self.movies_result
            self.movies_result = allMovies
            //Refresh tableview
            DispatchQueue.main.async {
                self.movies_result.shuffle()
                self.tableVieww.reloadData()
            }
        }
        
        task.resume()
    }
    
}


extension SearchViewController:UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return movies_result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("movieee modellll ..... \(movies_result[indexPath.row])")
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        cell.delegate = self
        for movie in favourite_movies_array {
            if( movie.imdbID == movies_result[indexPath.row].imdbID) {
                cell.configure(model: movies_result[indexPath.row],favourite: true)
                return cell
            }
        }
        cell.configure(model: movies_result[indexPath.row],favourite: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        snipper.show(in: view)
        let model = movies_result[indexPath.row]
        print("id of seleected model .... \(model.imdbID)")
        search_movie_id(id: model.imdbID)
        print("movie informations .... \(String(describing: show_movie_model))")
        
        print("Searchbar")
       

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 370
    }
    
}
extension SearchViewController:UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        movies_result.removeAll()
        print("search bottun clicked\(String(describing: searchBar.text))")
        if let text = searchBar.text , !text.isEmpty {
            print("not empty")
            SearchMovies_withName(query: text)
            SearchSeries_withName(query: text)
        }
        else {
            return
        }
        
    }
}

extension SearchViewController:MovieCellDelegate {

    
    func SaveButtonPressed(model: Movie) {
        print("movie model ... \(model)")

        var bool = false
        
        for  movie in favourite_movies_array {
            if movie.imdbID == model.imdbID {
                bool = true
                break
            }
        }
         
        if bool {
            //delete
            DatabaseManager.shared.deleteFavouriteMovie(email:(Auth.auth().currentUser?.email)!,id: model.imdbID) { [self] (Succeed) in
                if Succeed {
                    for i in (0..<favourite_movies_array.count) {
                        if  favourite_movies_array[i].imdbID == model.imdbID {
                            bool = true
                            favourite_movies_array.remove(at: i)
                            break
                        }
                    }
                    DispatchQueue.main.async {
                        //movies_result.shuffle()
                        self.tableVieww.reloadData()
                    }
                    return
                } else {
                    print("can't delete favourite movie")
                    return
                }
            }
            
        }
        
        else {
            snipper.show(in: view)
            DatabaseManager.shared.saveFavouriteMovies(email: (Auth.auth().currentUser?.email)!, movieModel: model) { [self] (succeed) in
                    if succeed {
                        favourite_movies_array.append(model)
                        DispatchQueue.main.async {
                            //movies_result.shuffle()
                            snipper.dismiss()
                            self.tableVieww.reloadData()
                        }
                    } else {
                        print("Can't save favourite movie")
                        
                    }
                }
            }
        }
        
    }
    

