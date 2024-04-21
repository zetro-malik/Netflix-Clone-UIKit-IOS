//
//  TitlePreviewViewController.swift
//  Netflix Clone
//
//  Created by Nayatel Creatives on 21/04/2024.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    
    var movieTitle: Title?
    
    
    private let webView: WKWebView = {
       let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false;
        return webView
    }()
    
    private let titleLabel: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = .systemFont(ofSize: 22,weight: .bold)
        lable.text = "harry porter"
        return lable
    }()
    
    private let overviewLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = .systemFont(ofSize: 18,weight: .regular)
        lable.numberOfLines = 0
        lable.text = "this is the best movie"
        return lable
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        
        
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLable)
        view.addSubview(downloadButton)
        
        configureConstraints()
    }
    
    func configureConstraints (){
        let webviewConstraints = [
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300),
        ]
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ]
        
        
        let overviewLabelConstraints = [
            overviewLable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overviewLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ]
        
        let downloadButtonConstraints = [
        
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overviewLable.bottomAnchor, constant: 25),
            downloadButton.widthAnchor.constraint(equalToConstant: 140),
            downloadButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        
        NSLayoutConstraint.activate(webviewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    
    func configure(with model: TitlePreviewViewModel, title: Title?) {
        
        titleLabel.text = model.title
        overviewLable.text = model.titleOverview
        print(model.youtube)
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtube.id.videoId)") else {
            return
        }
        
        print(url)
        
        webView.load(URLRequest(url: url))
        
        
       
        self.movieTitle = title
        
        
        
        downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
    }
    
    
    
    @objc private func downloadButtonTapped() {
    
        
        
        guard let title = movieTitle else {
             return
        }
         
        DataPersistanceManager.shared.downloadTitleWith(model: title) { results in
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
