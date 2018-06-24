//
//  SearchPresenterProtocol.swift
//  iTunesSearchTest
//
//  Created by SpaceGhost on 6/22/18.
//  Copyright © 2018 SpaceGhost. All rights reserved.
//

import UIKit

protocol SearchListPresenterProtocol: class {
    var view: SearchListViewProtocol? { get set }
    var interactor: SearchListInteractorInputProtocol? { get set }
    var wireFrame: SearchListWireFrameProtocol? { get set }
    
    // VIEW -> PRESENTER
    func viewDidLoad()
    func searchItunesWith(searchTerm term: String?)
}
protocol SearchListWireFrameProtocol: class {
    static func createSearchModule() -> UIViewController
}
protocol SearchListViewProtocol: class {
    var presenter: SearchListPresenterProtocol? { get set }
    
    // PRESENTER -> VIEW
    func prepareTableView()
    
    func showResults(with tracks: [Track])
    
    func showInitial()
    
    func showError()
    
    func showLoading()
    
    func showEmpty()
}
protocol SearchListInteractorOutputProtocol: class {
    // INTERACTOR -> PRESENTER
    func didRetrieveResults(_ tracks: [Track])
    func showEmpty()
    func onError()
}

protocol SearchListInteractorInputProtocol: class {
    var presenter: SearchListInteractorOutputProtocol? { get set }
    var remoteDatamanager: SearchListRemoteDataManagerInputProtocol? { get set }
    
    // PRESENTER -> INTERACTOR
    func retrieveTrackOrArtist(forTerm searchTerm: String?)
}

protocol SearchListRemoteDataManagerOutputProtocol: class {
    // REMOTEDATAMANAGER -> INTERACTOR
    func onResutlsRetrieved(withTracks tracks: [Track])
    func onError()
}
protocol SearchListRemoteDataManagerInputProtocol: class {
    var remoteRequestHandler: SearchListRemoteDataManagerOutputProtocol? { get set }
    // INTERACTOR -> REMOTEDATAMANAGER
    func retrieveResultsList(withSearchTerm term: String)
}
