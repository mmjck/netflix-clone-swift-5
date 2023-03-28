//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Jackson Matheus on 18/03/23.
//

import UIKit


class SearchViewController: UIViewController {
    
    
    public var titles: [Title] = [Title]()
    
    private let discoveryTable: UITableView =  {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    
    private let searchController: UISearchController  = {
        let search = UISearchController(searchResultsController: SearchResultsViewController())
        search.searchBar.placeholder = "Search for a Movie or a TV show"
        search.searchBar.searchBarStyle = .minimal
        return search
    }()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = .systemBackground
        
        
        title = "Search "
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        
        self.view.addSubview(discoveryTable)
        
        
        discoveryTable.delegate = self
        discoveryTable.dataSource = self
        
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        fetchDiscoveryMovies()
        
        
        searchController.searchResultsUpdater = self
    }
    
    
    override func viewDidLayoutSubviews() {
        discoveryTable .frame = self.view.bounds
    }
    
    
    
    private func fetchDiscoveryMovies(){
        APICaller.shared.getDiscoverMovies{ result in
            switch result {
            case .success(let _titles):
                self.titles = _titles
                DispatchQueue.main.async {
                    self.discoveryTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: title.original_name ??  title.original_title ?? "Unknow", posterURL: title.poster_path ?? ""))
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_name ?? title.original_title else {
            return
        }
        
        APICaller.shared.getMovie(with: titleName){ [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
            
        }
    }
    
}


extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        
        
        resultsController.delegate = self
        
        APICaller.shared.search(with: query) {
            result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultsController.titles = titles
                    resultsController.searchResultsColletionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension SearchViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

