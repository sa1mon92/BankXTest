//
//  TracksTableViewCell.swift
//  BankHlynovTest
//
//  Created by Дмитрий Садырев on 17.11.2022.
//

import UIKit
import SDWebImage

class TracksTableViewCell: UITableViewCell {
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackImageView.image = nil
        trackNameLabel.text = ""
    }
    
    func setup(model: BestTracksModel.BestTracks.Track) {
        if let urlString = model.image.first?.urlString,
           let url = URL(string: urlString) {
            trackImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            trackImageView.sd_setImage(with: url, placeholderImage: Constants.placeholderImage)
        } else {
            trackImageView.image = Constants.placeholderImage
        }
        if let trackName = model.name, let artistName = model.artist.name {
            artistNameLabel.text = artistName
            trackNameLabel.text = trackName
        }
    }
}
