//
//  SearchResultsViewController.swift
//  Netflix Clone
//
//  Created by Nayatel Creatives on 21/04/2024.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel, title: Title?)
}

class SearchResultsViewController: UIViewController {
    
    
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    public var titles: [Title] = [Title]()
    
    public let searchResultsCollectionView: UICollectionView =  {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero
            ,collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.indentifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
    
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.indentifier, for: indexPath) as? TitleCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        cell.configure(with: titles[indexPath.row].poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let title = titles[indexPath.row]
        
        APICaller.getMovie(with: titles[indexPath.row].original_title ?? "", completionHandler:  {[weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let title = self?.titles[indexPath.row].original_title ?? "unknow"
                    let overview = self?.titles[indexPath.row].overview ?? "unknow"
                    let viewModel = TitlePreviewViewModel(title: title , youtube: videoElement, titleOverview: overview )
                    
                    self?.delegate?.searchResultsViewControllerDidTapItem(viewModel, title: self?.titles[indexPath.row])
                    
                }
               case .failure(let error):
                print(error)
            }
            
        })
    }
    
   
    
     
}
