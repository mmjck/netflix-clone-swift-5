//
//  SearchResultsViewController.swift
//  Netflix Clone
//
//  Created by Jackson Matheus on 23/03/23.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    public var titles: [Title] = [Title]()

    
    public let searchResultsColletionView: UICollectionView = {
        let layout  = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 100)
        layout.minimumInteritemSpacing = .zero
        
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleColletionViewCell.self, forCellWithReuseIdentifier: TitleColletionViewCell.identifier)
        
        return collectionView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        
        self.view.addSubview(searchResultsColletionView)
        
        self.searchResultsColletionView.delegate = self
        self.searchResultsColletionView.dataSource = self
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchResultsColletionView.frame = self.view.bounds
    }
    
    
    
    
}


extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleColletionViewCell.identifier, for: indexPath) as? TitleColletionViewCell else {
            return UICollectionViewCell()
        }
        
        
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        
        
        return cell
    }
    
}
