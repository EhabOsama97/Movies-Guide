//
//  MovieTableHeaderCell.swift
//  MovieApp
//
//  Created by Ehab Osama on 2/14/21.
//

import UIKit

class MovieTableHeaderCell: UITableViewHeaderFooterView {

    @IBOutlet weak var movie_image_view: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        movie_image_view.layer.borderWidth = 3
        movie_image_view.layer.masksToBounds = false
        movie_image_view.layer.cornerRadius = 20
        movie_image_view.clipsToBounds = true
        movie_image_view.layer.borderColor = UIColor.systemPink.cgColor
        //movie_image_view.contentMode = .scaleToFill
        
    }
    
    public func confugure (posterURLString :String) {
        movie_image_view.sd_setImage(with: URL(string: posterURLString), completed: nil)
    }

    
}
