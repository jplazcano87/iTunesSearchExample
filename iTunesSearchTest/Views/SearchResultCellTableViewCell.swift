//
//  SearchResultCellTableViewCell.swift
//  iTunesSearchTest
//
//  Created by SpaceGhost on 6/21/18.
//  Copyright © 2018 SpaceGhost. All rights reserved.
//

import UIKit

class SearchResultCellTableViewCell: UITableViewCell {
    
    static let ReuseIdentifier = String(describing: SearchResultCellTableViewCell.self)
    static let NibName = String(describing: SearchResultCellTableViewCell.self)
    
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCell(withTrack track: Track) {
        trackLabel.text = track.trackName
        artistLabel.text = track.artistName
    }
    
}
