//
//  CollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by Nayatel Creatives on 14/04/2024.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel, title: Title?)
}

class CollectionViewTableViewCell: UITableViewCell {
  
    
    static let indentifier = "CollectionViewTableViewCell"
    
    weak var delegate:CollectionViewTableViewCellDelegate?
    
    private var titles: [Title] = [Title]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register( TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.indentifier)
        return collectionView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
      
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with titles: [Title]){
        self.titles = titles
        
        DispatchQueue.main.async {
            [weak self] in
            
            self?.collectionView.reloadData()
        }
    }
    
    
    private func downloadTitleAt(indexPath: IndexPath){
        
        DataPersistanceManager.shared.downloadTitleWith(model: titles[indexPath.row]) { results in
            switch results {
            case .success():
                NotificationCenter.default.post(name: Notification.Name("downloaded"),object: nil)
                //showSuccessAlert()
            case .failure(let error):
                print(error)
            }
        }
    }
}

func showSuccessAlert() {
    let alertController = UIAlertController(title: "Success", message: "Downloading completed successfully", preferredStyle: .alert)
    
    // Add an OK button to dismiss the alert
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    
    // Present the alert
    DispatchQueue.main.async {
        // Ensure UI updates are performed on the main thread
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            topViewController.present(alertController, animated: true, completion: nil)
        }
    }
}


extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.indentifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let model = titles[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        cell.configure(with:  model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let titleName = titles[indexPath.row].original_title ?? titles[indexPath.row].original_name  else {
            return
        }
        print(titleName + " trailer")
        APICaller.getMovie(with: titleName + " trailer", completionHandler:  {[weak self] result in
            switch result {
            case .success(let videoElement):
                let title = self?.titles[indexPath.row].original_title ?? self?.titles[indexPath.row].original_name ?? "unknow"
                let overview = self?.titles[indexPath.row].overview ?? "unknow"
                
                let viewModel = TitlePreviewViewModel(title: title , youtube: videoElement, titleOverview: overview )
                self?.delegate?.collectionViewTableViewCellDidTapCell(self!, viewModel:viewModel, title: self?.titles[indexPath.row] )
            case .failure(let error):
                print(error)
            }
            
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        // Retrieve the item at the specified indexPath
    
        
        // Create and return a menu configuration
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) {[weak self] _ in
                // Create a UIAction for the "Download" action
                let downloadAction = UIAction(
                    title: "Download",
                    image: UIImage(systemName: "arrow.down.circle")) { _ in
                        self?.downloadTitleAt(indexPath: indexPath)
                }
                
                
                return UIMenu(
                    title: "",
                    image: nil,
                    identifier: nil,
                    options: .displayInline,
                    children: [downloadAction]
                )
        }
        
        return config
    }


   

}

