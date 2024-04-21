//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Nayatel Creatives on 14/04/2024.
//

import UIKit

enum Sections: Int{
    case TrendingMovie = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController{
    
    private var randomTrendingMovie: Title?
    private var headerView: HeroHearderUIView?
    
    
    let sectionTitles: [String] = ["Trending Movies" , "Popular" , "Trending Tv", "Upcoming Movies", "Top Rated"]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier:  CollectionViewTableViewCell.indentifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavBar()
    
        headerView = HeroHearderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        
        configureHeroHeaderView()
        
        //navigationController?.pushViewController(TitlePreviewViewController(), animated: true)
    }
    
    
    private func configureHeroHeaderView() {
        
        APICaller.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                self?.randomTrendingMovie = selectedTitle
                self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title, posterUrl: selectedTitle?.poster_path))
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
    
    
    
    override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         homeFeedTable.frame = view.bounds
    }
    
    
    
    func configureNavBar(){
        var image = UIImage(named: "netflixLogo")?.resizeTo(size: CGSize(width: 25, height: 35))
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem  = UIBarButtonItem(image: image, style: .done , target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }

}








extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.indentifier, for: indexPath) as? CollectionViewTableViewCell else{
            return UITableViewCell()
        }
        
        cell.delegate = self
        switch indexPath.section {
        case Sections.TrendingMovie.rawValue:
            
            
            APICaller.getTrendingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error)
                }
            }
            
            
        case Sections.TrendingTv.rawValue:
            
            APICaller.getTrendingTv { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error)
                }
            }
            
            
        case Sections.Popular.rawValue:
            
            APICaller.getPopularMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error)
                }
            }
            
            
        case Sections.Upcoming.rawValue:
            
            APICaller.getUpcomingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error)
                }
            }
            
        case Sections.TopRated.rawValue:
            
            APICaller.getTopRatedMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error)
                }
            }
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0,-offset))
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView   , forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y + 20, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
       header.textLabel?.text = header.textLabel?.text?.capitilizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    
}



extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel, title: Title?) {
        DispatchQueue.main.async{
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel, title: title)
            self.navigationController? .pushViewController(vc, animated: true)
        }
    }
    
}
