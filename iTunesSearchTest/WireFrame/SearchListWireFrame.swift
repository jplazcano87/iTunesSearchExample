//
//  SearchListWireFrame.swift
//  iTunesSearchTest
//
//  Created by SpaceGhost on 6/22/18.
//  Copyright © 2018 SpaceGhost. All rights reserved.
//

import UIKit

class SearchListWireFrame: SearchListWireFrameProtocol {
    // MARK: Static Computed Properties
    private static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    static func createSearchModule() -> UIViewController {
        guard let searchView =
            mainStoryboard.instantiateViewController(withIdentifier: SearchViewController.viewIdentifier) as? SearchViewController else {
            fatalError()
        }
        let presenter = SearchListPresenter()
        let interactor = SearchListInteractor()
        let remoteDataManager = SearchListRemoteDataManager()
        let wireFrame  = SearchListWireFrame()
        searchView.presenter = presenter
        presenter.view = searchView
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.remoteDatamanager = remoteDataManager
        remoteDataManager.remoteRequestHandler = interactor
        return searchView
    }
}
