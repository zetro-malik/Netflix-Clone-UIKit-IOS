//
//  TitleCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Nayatel Creatives on 14/04/2024.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    
    static let indentifier = "TitleUICollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    public func configure(with model: String){
        guard let url = URL(string: "\(NetworkConstants.shared.imageServerAdress)\(model)") else {
            return
        }
        posterImageView.sd_setImage(with: url,completed: nil)
    }
    

    
}
