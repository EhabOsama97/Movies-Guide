//
//  MovieViewController.swift
//  MovieApp
//
//  Created by Ehab Osama on 2/14/21.
//

import UIKit
import SDWebImage
import SafariServices

class MovieViewController: UIViewController {

    @IBOutlet weak var Movie_table_view: UITableView!
    
    var lableArray = ["Plot : ","Actors : ","Generation : ","Awards : ", "Time : ", "Rating : ","Year : "]
    
    public var movie_model:MovieIDStruct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Movie_table_view.delegate = self
        self.Movie_table_view.dataSource = self
        self.Movie_table_view.showsVerticalScrollIndicator = false
        
        self.Movie_table_view.register(UINib(nibName: "MovieTableHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "MovieTableHeaderCell")
        
        self.Movie_table_view.register(UINib(nibName: "MovieTableFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "MovieTableFooter")
        
        self.Movie_table_view.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        
        
        //model variables
        title = movie_model?.Title
        navigationController?.navigationBar.prefersLargeTitles = true
        print("movie show model ..... \(String(describing: movie_model))")
        
    }

}

extension MovieViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        if let movieModel = movie_model {
            cell.configration(model: movieModel, label: lableArray[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MovieTableHeaderCell") as! MovieTableHeaderCell
        if let poster = movie_model?.Poster {
            headerCell.confugure(posterURLString: poster)

        }
        return headerCell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MovieTableFooter") as! MovieTableFooter
        footerCell.delegate = self
        return footerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
    
    
}

extension MovieViewController : footerDelegate {
    func trailer_btn_pressed() {
        guard let movieID = movie_model?.imdbID,let url = URL(string: "https://www.imdb.com/title/\(movieID)/") else {
            print("dkhal fe el return")
            return
        }
        print("el mfrod yft7 el url")
        let vc = SFSafariViewController(url: url)
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)        }
    }
    
    
}
