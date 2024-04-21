//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Nayatel Creatives on 14/04/2024.
//

import UIKit

class SearchViewController: UIViewController {
    
    
    
    
    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }();
    
    private let SearchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a Movie or a Tv show"
        controller.searchBar.searchBarStyle = .minimal
        return controller;
    }()
    
    private var titles: [Title] = [Title]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(discoverTable)
        
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
    
        
        navigationItem.searchController = SearchController
        navigationController?.navigationBar.tintColor = .white
        
        SearchController.searchResultsUpdater = self;
        
        fetchDiscoverMovies()
    }
    
    
  
    
    private func fetchDiscoverMovies(){
        APICaller.getDiscoverMovies { [weak self] result in
            switch result{
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure( let error):
                print(error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier) as? TitleTableViewCell else{
            return UITableViewCell()
        }
        
        cell.configure(with: TitleViewModel(titleName: titles[indexPath.row].original_title ?? "unknown name", posterUrl: titles[indexPath.row].poster_path ?? ""))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        
        APICaller.getMovie(with: titles[indexPath.row].original_title ?? "", completionHandler:  {[weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let title = self?.titles[indexPath.row].original_title ?? "unknow"
                    let overview = self?.titles[indexPath.row].overview ?? "unknow"
                    let viewModel = TitlePreviewViewModel(title: title , youtube: videoElement, titleOverview: overview )
                    let vc = TitlePreviewViewController()
                    vc.configure(with: viewModel,title: self?.titles[indexPath.row])
                   
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
               case .failure(let error):
                print(error)
            }
            
        })
    }
    
}


extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {

    
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel, title: Title?) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel, title: title)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
   
    
    func updateSearchResults(for searchController: UISearchController) {
        
    
      
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty, query.trimmingCharacters(in: .whitespaces).count >= 3, let resultsContoller = SearchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        resultsContoller.delegate = self
        
        APICaller.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultsContoller.titles = titles
                    resultsContoller.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        
    }
    

}
