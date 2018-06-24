//
//  SearchPresenter.swift
//  iTunesSearchTest
//
//  Created by SpaceGhost on 6/22/18.
//  Copyright © 2018 SpaceGhost. All rights reserved.
//

import Foundation

class SearchListPresenter: SearchListPresenterProtocol {

    weak var view: SearchListViewProtocol?
    var interactor: SearchListInteractorInputProtocol?
    var wireFrame: SearchListWireFrameProtocol?
    
    func viewDidLoad() {
        view?.prepareTableView()
        view?.showInitial()
    }
    
    func searchItunesWith(searchTerm term: String?) {
        interactor?.retrieveTrackOrArtist(forTerm: term)
    }
}
extension SearchListPresenter: SearchListInteractorOutputProtocol {
    func didRetrieveResults(_ tracks: [Track]) {
        view?.showResults(with: tracks)
    }
    
    func showEmpty() {
        view?.showEmpty()
    }
    
    func onError() {
        view?.showError()
    }
}
