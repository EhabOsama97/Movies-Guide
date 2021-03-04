//
//  MovieTableFooter.swift
//  MovieApp
//
//  Created by Ehab Osama on 2/14/21.
//

import UIKit

protocol footerDelegate {
    func trailer_btn_pressed()
}
class MovieTableFooter: UITableViewHeaderFooterView {

    @IBOutlet weak var trailer_btn: UIButton!
    public var delegate:footerDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        trailer_btn.layer.cornerRadius = 20
    }

    
    @IBAction func trailer_btn_pressed(_ sender: UIButton) {
        delegate.trailer_btn_pressed()
    }
    
}
