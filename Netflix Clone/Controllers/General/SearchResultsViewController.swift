//
//  SearchResultsViewController.swift
//  Netflix Clone
//
//  Created by Jackson Matheus on 23/03/23.
//

import UIKit


protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
}

class SearchResultsViewController: UIViewController {
    
    public var titles: [Title] = [Title]()
    
    
    public weak var delegate:SearchResultsViewControllerDelegate?

    
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
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        
        let title = titles[indexPath.row]
        let titleName = title.original_title ?? ""
        APICaller.shared.getMovie(with: titleName){ [weak self] result in
            switch result {
            case .success(let videoElement):
                self?.delegate?.searchResultsViewControllerDidTapItem(TitlePreviewViewModel(title: title.original_name ?? title.original_title ?? "", youtubeView: videoElement, titleOverview: title.overview ?? ""))

            case .failure(let error):
                print(error.localizedDescription)
                
            }
            
        }
        
      
    }
}
