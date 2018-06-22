//
//  TableViewState.swift
//  iTunesSearchTest
//
//  Created by SpaceGhost on 6/21/18.
//  Copyright © 2018 SpaceGhost. All rights reserved.
//

import Foundation

enum State {
    case initial
    case loading
    case populated
    case empty
    case error(Error)
}
