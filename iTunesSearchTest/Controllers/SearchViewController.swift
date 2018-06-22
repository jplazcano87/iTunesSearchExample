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
    @IBOutlet var errorView: UIView!
    @IBOutlet var emptyView: UIView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var loadingView: UIView!
    // MARK: - Constants
    private let rowHeigth: CGFloat = 70.0
    
    // MARK: - Injections
    internal var networkClient = NetworkClient.shared
    
    // MARK: Stored Properties
    private var searchResults = [Track]()
    private var defaultSession: DHURLSession = URLSession(configuration: URLSessionConfiguration.default)
    private var dataTask: URLSessionDataTask?
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard))
    }()
    private var state = State.initial {
        didSet {
            setFooterView()
            resultsTableView.reloadData()
        }
    }
    
    // MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
    }
    
    // MARK: Keyboard dismissal
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    // MARK: Internal Methods
    private func prepareTableView() {
        let nib = UINib(nibName: SearchResultCellTableViewCell.NibName, bundle: .main)
        resultsTableView.register(nib, forCellReuseIdentifier: SearchResultCellTableViewCell.ReuseIdentifier)
        state = .initial
    }
    // MARK: - View Configuration
    func setFooterView() {
        switch state {
        case .initial:
             emptyLabel.text = "Try searching by 👨‍🎤 Artist or 🎵 Song"
             resultsTableView.tableFooterView = emptyView
        case .error(let error):
            errorLabel.text = error.localizedDescription
            resultsTableView.tableFooterView = errorView
        case .loading:
            resultsTableView.tableFooterView = loadingView
        case .empty:
                emptyLabel.text = "No results 🎶"
            resultsTableView.tableFooterView = emptyView
        case .populated:
            resultsTableView.tableFooterView = nil
        }
    }
    
}
// MARK: SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        state = .loading
        networkClient.getTrackOrArtist(forTerm: text, { [weak self] tracks in
            guard let strongSelf = self else { return }
            strongSelf.searchResults = tracks
            strongSelf.state = tracks.isEmpty ? .empty : .populated
            strongSelf.resultsTableView.setContentOffset(CGPoint.zero, animated: false)
            }, { [weak self] error in
                guard let strongSelf = self else { return }
                strongSelf.state = .error(error)
        })
    }
    // MARK: Keyboard handler methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapRecognizer)
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
                return UITableViewCell()
        }
        let track = searchResults[indexPath.row]
        cell.configureCell(withTrack: track)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeigth
    }
}
