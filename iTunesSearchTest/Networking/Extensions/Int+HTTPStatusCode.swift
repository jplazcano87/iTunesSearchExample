//
//  Int+HTTPStatusCode.swift
//  iTunesSearchTest
//
//  Created by SpaceGhost on 6/21/18.
//  Copyright © 2018 SpaceGhost. All rights reserved.
//

import Foundation

extension Int {
    public var isSuccessHTTPCode: Bool {
        return 200 <= self && self < 300
    }
}
