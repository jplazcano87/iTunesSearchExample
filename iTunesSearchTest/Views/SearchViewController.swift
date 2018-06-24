//
//  ViewController.swift
//  iTunesSearchTest
//
//  Created by SpaceGhost on 6/20/18.
//  Copyright © 2018 SpaceGhost. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!
    // MARK: - Constants
    private let rowHeigth: CGFloat = 70.0
    public static let viewIdentifier = String(describing: SearchViewController.self)
    
    // MARK: Public Properties
    var presenter: SearchListPresenterProtocol?
    
    // MARK: Stored Properties
    private var searchResults = [Track]()
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard))
    }()
    
    // MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        searchBar.becomeFirstResponder()
    }
    
    // MARK: Keyboard dismissal
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
}
// MARK: SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        searchResults.removeAll()
        presenter?.searchItunesWith(searchTerm: searchBar.text)
    }
    // MARK: Keyboard handler methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapRecognizer)
    }
}
extension SearchViewController: SearchListViewProtocol {
    func showError(_ errorDescription: String) {
        errorLabel.text = errorDescription
        resultsTableView.tableFooterView = errorView
    }
    
    func reloadData() {
        resultsTableView.reloadData()
    }
    
    func prepareTableView() {
        let nib = UINib(nibName: SearchResultCellTableViewCell.NibName, bundle: .main)
        resultsTableView.register(nib, forCellReuseIdentifier: SearchResultCellTableViewCell.ReuseIdentifier)
    }
    
    func showResults(with tracks: [Track]) {
        searchResults = tracks
        resultsTableView.tableFooterView = nil
    }
    
    func showInitial() {
        emptyLabel.text = "Try searching by 👨‍🎤 Artist or 🎵 Song"
        resultsTableView.tableFooterView = emptyView
    }

    func showLoading() {
        resultsTableView.tableFooterView = loadingView
    }
    
    func showEmpty() {
        emptyLabel.text = "No results 🎶"
        resultsTableView.tableFooterView = emptyView
    }
}
// MARK: TableView Delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultCellTableViewCell.ReuseIdentifier)
            as? SearchResultCellTableViewCell else {
                return SearchResultCellTableViewCell()
        }
        let track = searchResults[indexPath.row]
        cell.configureCell(withTrack: track)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeigth
    }
}
