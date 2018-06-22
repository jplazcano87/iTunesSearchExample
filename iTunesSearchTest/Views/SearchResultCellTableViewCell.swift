//
//  SearchResultCellTableViewCell.swift
//  iTunesSearchTest
//
//  Created by SpaceGhost on 6/21/18.
//  Copyright © 2018 SpaceGhost. All rights reserved.
//

import UIKit

class SearchResultCellTableViewCell: UITableViewCell {
    // MARK: Constants
    static let ReuseIdentifier = String(describing: SearchResultCellTableViewCell.self)
    static let NibName = String(describing: SearchResultCellTableViewCell.self)
    // MARK: IBOutlets
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    // MARK: Cell Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    // MARK: Cell Configuration
    func configureCell(withTrack track: Track) {
        trackLabel.text = "🎵 \(track.trackName)"
        artistLabel.text = "👨‍🎤 \(track.artistName)"
    }
}
