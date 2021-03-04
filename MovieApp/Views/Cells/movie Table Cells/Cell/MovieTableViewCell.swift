//
//  MovieTableViewCell.swift
//  MovieApp
//
//  Created by Ehab Osama on 2/14/21.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var Description_view: UIView!
    @IBOutlet weak var title_lable: UILabel!
    
    @IBOutlet weak var description_lable: UILabel!
    var MovieModel:MovieIDStruct?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Description_view.layer.cornerRadius = Description_view.frame.size.height / 5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configration (model:MovieIDStruct , label:String) {
        MovieModel = model
        title_lable.text = label
        
        print("label is \(label)")
        if label == "Plot : " {
            description_lable.text = model.Plot
        }
        else if label == "Actors : " {
            description_lable.text = model.Actors
        }
        else if label == "Generation : " {
            description_lable.text = model.Genre
        }
        else if label == "Awards : " {
            description_lable.text = model.Awards
        }
        else if label == "Time : " {
            description_lable.text = model.Runtime
        }
        else if label == "Rating : " {

                let attachment = NSTextAttachment()
                attachment.image = UIImage(systemName: "star.fill")
                let attachmentString = NSAttributedString(attachment: attachment)
                let string = NSMutableAttributedString(string: model.imdbRating + " ", attributes: [:])
                string.append(attachmentString)
                description_lable.attributedText = string
            

            //description_lable.text = model.imdbRating
        }
        else if label == "Year : " {
            description_lable.text = model.Year
        }
    }
    
    }
