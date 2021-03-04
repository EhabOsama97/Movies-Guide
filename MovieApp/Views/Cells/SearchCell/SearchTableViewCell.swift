//
//  SearchTableViewCell.swift
//  MovieApp
//
//  Created by Ehab Osama on 2/14/21.
//

import UIKit
import SDWebImage

protocol MovieCellDelegate {
    func SaveButtonPressed(model:Movie)
}

class SearchTableViewCell: UITableViewCell {

    var movieModel: Movie?
    var delegate:MovieCellDelegate!
    @IBOutlet weak var image_view: UIImageView!
    
    @IBOutlet weak var type_label: UILabel!
    @IBOutlet weak var year_lbl: UILabel!
    @IBOutlet weak var movieName_lbl: UILabel!
    @IBOutlet weak var Vieww: UIView!
    @IBOutlet weak var favourite_btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    public func configure(model:Movie,favourite:Bool) {
        movieModel = model
        Vieww.layer.cornerRadius = 20
        Vieww.clipsToBounds = true
        image_view.layer.borderWidth = 4
        image_view.layer.masksToBounds = false
        image_view.layer.cornerRadius = 20
            //image_view.bounds.height / 2.0
        image_view.clipsToBounds = true
        image_view.layer.borderColor = UIColor.label.cgColor
        image_view.contentMode = .scaleToFill
        
        let imageURL = URL(string: model.Poster)
        image_view.sd_setImage(with: imageURL, completed: nil)
        movieName_lbl.text = model.Title
        year_lbl.text = model.Year
        type_label.text = model._Type
        
        if favourite {
            favourite_btn.imageView?.image = UIImage(systemName: "bookmark.fill")
        }

        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func save_button_pressed(_ sender: UIButton) {
        delegate.SaveButtonPressed(model: movieModel!)
    }
    
}
