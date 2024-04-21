//
//  TitleTableViewCell.swift
//  Netflix Clone
//
//  Created by Nayatel Creatives on 14/04/2024.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    static let identifier = "TitleTableViewCell"
    
    private let playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle",withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        button.setImage(image,for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let titlePosterUiImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titlePosterUiImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playButton)
        
        applyConstraints()
    }
    
    
    private func applyConstraints(){
        let titlePosterUiImageViewConstraints = [
            titlePosterUiImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titlePosterUiImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titlePosterUiImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titlePosterUiImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: titlePosterUiImageView.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        
        let playButtonConstrainst = [
            playButton.trailingAnchor.constraint(equalTo:  contentView.trailingAnchor, constant: -20),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 50)
        ]
        
        
        NSLayoutConstraint.activate(titlePosterUiImageViewConstraints)
        NSLayoutConstraint.activate(playButtonConstrainst)
        NSLayoutConstraint.activate(titleLabelConstraints)
        
        
    }
    
    public func configure(with model: TitleViewModel){
        guard let url = URL(string: "\(NetworkConstants.shared.imageServerAdress)\(model.posterUrl ?? "")")else{
            return
        }
        titlePosterUiImageView.sd_setImage(with: url)
        titleLabel.text = model.titleName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
