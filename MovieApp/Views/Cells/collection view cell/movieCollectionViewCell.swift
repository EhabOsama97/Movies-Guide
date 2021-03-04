//
//  movieCollectionViewCell.swift
//  MovieApp
//
//  Created by Ehab Osama on 2/16/21.
//

import UIKit
import SDWebImage

protocol collection_cell_delegate {
    func save_btn_pressed(model:Movie)
}

class movieCollectionViewCell: UICollectionViewCell {

    var delegate:collection_cell_delegate!
    @IBOutlet weak var favourite_btn: UIButton!
    @IBOutlet weak var name_label: UILabel!
    var movieModel:Movie?
    @IBOutlet weak var type_label: UILabel!
    @IBOutlet weak var year_label: UILabel!
    @IBOutlet weak var image_view: UIImageView!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    public func configure(model:Movie,favourite:Bool) {
        movieModel = model
        if movieModel?._Type == "movie" {
            type_label.textColor = UIColor.systemBlue
            image_view.layer.borderColor = UIColor.systemBlue.cgColor

        } else {
            type_label.textColor = UIColor.systemPink
            image_view.layer.borderColor = UIColor.systemPink.cgColor

        }
        favourite_btn.isHidden = true
        image_view.layer.borderWidth = 4
        image_view.layer.masksToBounds = false
        image_view.layer.cornerRadius = 20
            //image_view.bounds.height / 2.0
        image_view.clipsToBounds = true
        //image_view.layer.borderColor = UIColor.systemPink.cgColor
        image_view.contentMode = .scaleToFill
        
        let imageURL = URL(string: model.Poster)
        image_view.sd_setImage(with: imageURL, completed: nil)
        name_label.text = model.Title
        year_label.text = model.Year
        type_label.text = model._Type
        
        if favourite {
            favourite_btn.imageView?.image = UIImage(systemName: "bookmark.fill")
        }
  
    }
    
    
    @IBAction func favourite_btn_press(_ sender: UIButton) {
        delegate.save_btn_pressed(model: movieModel!)
    }
    
}
