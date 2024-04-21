//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by Nayatel Creatives on 14/04/2024.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    
    private var titles: [Title] = [Title]()
    
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        fetchUpcomingMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    
    private func fetchUpcomingMovies (){
        APICaller.getUpcomingMovies {[weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error)
                
            }
        }
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = upcomingTable.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: TitleViewModel(titleName: titles[indexPath.row].original_title, posterUrl: titles[indexPath.row].poster_path))
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
                    vc.configure(with: viewModel, title: self?.titles[indexPath.row])
                   
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
               case .failure(let error):
                print(error)
            }
            
        })
    }
    
    
}
