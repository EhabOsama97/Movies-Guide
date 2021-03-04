//
//  ViewController.swift
//  MovieApp
//
//  Created by Ehab Osama on 2/7/21.
//

import UIKit
import FirebaseAuth
import SideMenu
import JGProgressHUD


class HomeViewController: UIViewController, UINavigationControllerDelegate {

    private let snipper = JGProgressHUD(style:  .dark)
    var refreshControl = UIRefreshControl()
    //movies variables
    
    @IBOutlet weak var Movie_collection_view: UICollectionView!
    var movies_result = [Movie]()
    var movies_array = [Movie]()
    var series_array = [Movie]()
    
    var search_queries_array = ["of","why","my","dark","hey","county","car","what","boy","girl","animal","hair","eyes","social","fast","and","sea","water","shark","glasses","cat","dog","fast","kiss","red","yellow","fast","monkey","mouse","human","humans","luck","lucky","who","bank","germany","barcelona","love","sad","sadness","romantic","cry","war","wars","sex","no","yes","small","big","brave","tree","trees","water","see","sea","enjoy" ]
    
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
    //-------------------------
    
  //Variables
    private var SideMenu:SideMenuNavigationController?
    
    
    
//---------------------------------------
    
    //ViewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        make_mocked_data()
        //movies api
        Movie_collection_view.register(UINib(nibName: "movieCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "movieCollectionViewCell")
        Movie_collection_view.delegate = self
        Movie_collection_view.dataSource = self
        Movie_collection_view.showsVerticalScrollIndicator = false
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh_func), for: .valueChanged)
        Movie_collection_view.addSubview(refreshControl)
     
        
        //-----------------------
       
        
        
       //navigation bar buttons
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.star"), style: .done, target: self, action: #selector(showSlideMenu))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: #selector(showSearchBar))
        //-------------------------
        
        //SideMenu
        let menuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MenuViewController") as! MenuViewController
        menuVC.delegate = self
        SideMenu = SideMenuNavigationController(rootViewController: menuVC)
        SideMenu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = SideMenu
        SideMenu?.menuWidth = 280
        SideMenu?.delegate = self
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        //-------------------------

    }
    //-------------------------
    
    //viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        check_Auth()
    }
    //-------------------------
    @objc func refresh_func()  {
        self.viewDidLoad()
        refreshControl.endRefreshing()
    }
    func check_Auth() {
        if Auth.auth().currentUser == nil {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyBoard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            loginVC.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(loginVC, animated: true, completion: nil)
            }
            
        }
    }
    

    
    //objc Functions
    @objc func showSlideMenu () {
        print("Slide Menu")
        
        present(SideMenu!, animated: true, completion: nil)
    }
    
    @objc func showSearchBar () {
        print("Searchbar")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let searchVC = storyBoard.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
        searchVC.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(searchVC, animated: true)
        }
    }
    //-------------------------

}

//api functions
extension HomeViewController {
    
    func make_mocked_data ()
    {
        for  i in (0 ..< 5 ){
            let randomNumber = Int.random(in: 0 ..< search_queries_array.count-i)
            SearchMovies_withName(query: search_queries_array[randomNumber])
            //search_queries_array.remove(at: randomNumber)
        }
        for  i in (0 ..< 5 ){
            
            let randomNumber:Int?
            if (0>search_queries_array.count-i) {
                randomNumber = 0
            }
            else {
                randomNumber = Int.random(in: 0 ..< search_queries_array.count-i)
            }
            
            SearchSeries_withName(query: search_queries_array[randomNumber!])
            //search_queries_array.remove(at: randomNumber!)

        }
        print("all movies and series count ... \(movies_result.count)")
    }
    
    func SearchMovies_withName(query:String) {
        print("text of query .... \(query)")
        let newQuery = query.replacingOccurrences(of: " ", with: "%20")
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
//                DispatchQueue.main.async {
//                    self.tableVieww.reloadData()
//                }
//
                return
            }
            
            //update our movies array
            let newMovies = finalResult.Search
            //self.movies.append(contentsOf: newMovies)
            let allMovies = newMovies + self.movies_result
            self.movies_result = allMovies
            //Refresh tableview
            DispatchQueue.main.async {
                self.Movie_collection_view.reloadData()
            }
        }
        
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
                    self.Movie_collection_view.reloadData()
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
                self.Movie_collection_view.reloadData()
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
    
}
//--------------------------

//collection view functions

extension HomeViewController:UICollectionViewDelegate , UICollectionViewDataSource {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies_result.shuffle()
        return movies_result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = Movie_collection_view.dequeueReusableCell(withReuseIdentifier: "movieCollectionViewCell", for: indexPath) as! movieCollectionViewCell
        cell.delegate = self
        cell.configure(model: movies_result[indexPath.row], favourite: false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        snipper.show(in: view)
        let model = movies_result[indexPath.row]
        print("id of seleected model .... \(model.imdbID)")
        search_movie_id(id: model.imdbID)
        print("movie informations .... \(String(describing: show_movie_model))")
        
        print("Searchbar")
        
    }
    
}



//--------------------------

//cell delegate
extension HomeViewController:MovieCellDelegate {
    func SaveButtonPressed(model: Movie) {
        
        print(movies_result.count)
    }
    
    
}
//--------------------------


//Side menu extension
extension HomeViewController:MenuViewControllerDelegate {
    
    func privacyButtenPressed() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let PrivacyVC = storyBoard.instantiateViewController(identifier: "PrivacyViewController") as! PrivacyViewController
        PrivacyVC.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.SideMenu?.dismiss(animated: true, completion: nil)
            self.navigationController?.pushViewController(PrivacyVC, animated: true)
    }
    }
    
   
    func ProfileButtonPressed() {
        print("Profile")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let ProfileVC = storyBoard.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
        ProfileVC.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.SideMenu?.dismiss(animated: true, completion: nil)
            self.navigationController?.pushViewController(ProfileVC, animated: true)
    }
    }
    
    func SettingButtonPressed() {
        print("Setting")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let SettingVC = storyBoard.instantiateViewController(identifier: "SettingViewController") as! SettingViewController
        SettingVC.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.SideMenu?.dismiss(animated: true, completion: nil)
            self.navigationController?.pushViewController(SettingVC, animated: true)
    }
    }
    
    
    func logoutButtonPressed() {
        print("logout")
        let alert = UIAlertController(title: "",
                                      message:"Are you sure to logout?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancle",
                                      style: .cancel,
                                      handler: nil))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (UIAlertAction) in
            
            AuthManager.shared.logOut { (secceed) in
                if secceed {
                    UserDefaults.standard.set(nil, forKey: "email")
                    UserDefaults.standard.set(nil, forKey: "password")
                    UserDefaults.standard.set(nil, forKey: "profileImage")

                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let LoginVC = storyBoard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
                    LoginVC.modalPresentationStyle = .fullScreen
                    
                    DispatchQueue.main.async {
                        self.present(LoginVC, animated: true, completion: nil)
                    }
                }
                else {
                    
                }
            }

        }))
        SideMenu?.dismiss(animated: true, completion: nil)
        present(alert, animated: true, completion: nil)
    }
    
    
}
//-------------------------------

//collectionView cell delegate
extension HomeViewController:collection_cell_delegate {
    func save_btn_pressed(model: Movie) {
        print(movies_result.count)
    }
    
    
}
