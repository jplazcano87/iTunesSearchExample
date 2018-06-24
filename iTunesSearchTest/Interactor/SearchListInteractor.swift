//
//  SearchListInteractor.swift
//  iTunesSearchTest
//
//  Created by SpaceGhost on 6/23/18.
//  Copyright © 2018 SpaceGhost. All rights reserved.
//

import Foundation

class SearchListInteractor: SearchListInteractorInputProtocol {
    var presenter: SearchListInteractorOutputProtocol?
    var remoteDatamanager: SearchListRemoteDataManagerInputProtocol?
    
    func retrieveTrackOrArtist(forTerm searchTerm: String?) {
        guard let searchTerm = searchTerm else {
            presenter?.onError()
            return
        }
        remoteDatamanager?.retrieveResultsList(withSearchTerm: searchTerm)
    }
}
extension SearchListInteractor: SearchListRemoteDataManagerOutputProtocol {
    func onResutlsRetrieved(withTracks tracks: [Track]) {
        presenter?.didRetrieveResults(tracks)
    }
    
    func onError() {
        presenter?.onError()
    }
}
