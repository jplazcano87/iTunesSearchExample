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
            presenter?.onError("Invalid Search Text")
            presenter?.reloadData()
            return
        }
        remoteDatamanager?.retrieveResultsList(withSearchTerm: searchTerm)
    }
}
extension SearchListInteractor: SearchListRemoteDataManagerOutputProtocol {
    func onResutlsRetrieved(withTracks tracks: [Track]) {
        if tracks.isEmpty {
            presenter?.showEmpty()
        } else {
            presenter?.didRetrieveResults(tracks)
        }
        presenter?.reloadData()
    }
    
    func onError(error: NetworkError) {
        presenter?.onError(error.localizedDescription)
        presenter?.reloadData()
    }
}
