//
//  PlayingNowTableViewCell.swift
//  HumaTheMovieDBTestTask
//
//  Created by admin on 08.08.2021.
//

import UIKit

class PlayingNowTableViewCell: UITableViewCell {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var index: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with title: String, newIndex: Int) {
        titleLabel.text = title
        index = newIndex
        logo.image = UIImage(named: "empty")
    }
    
    func setLogo(with image: UIImage) {
        logo.image = image
    }
}
