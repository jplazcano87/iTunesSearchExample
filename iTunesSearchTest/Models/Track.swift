//
//  Track.swift
//  iTunesSearchTest
//
//  Created by SpaceGhost on 6/21/18.
//  Copyright © 2018 SpaceGhost. All rights reserved.
//

import Foundation

public struct Track: Decodable {
    var trackName: String
    var artistName: String
    var previewUrl: String
}
