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
        view?.showLoading()
        interactor?.retrieveTrackOrArtist(forTerm: term)
    }
}
extension SearchListPresenter: SearchListInteractorOutputProtocol {
    func onError(_ errorDescription: String) {
        view?.showError(errorDescription)
    }
    
    func reloadData() {
        view?.reloadData()
    }
    
    func didRetrieveResults(_ tracks: [Track]) {
        view?.showResults(with: tracks)
    }
    
    func showEmpty() {
        view?.showEmpty()
    }
}
