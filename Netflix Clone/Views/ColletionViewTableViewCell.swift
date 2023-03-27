//
//  ColletionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by Jackson Matheus on 18/03/23.
//

import UIKit


protocol ColletionViewTableViewCellDelegate: AnyObject {
    func colletionViewTableViewCellDidTapCell(_ cell:ColletionViewTableViewCell, viewModel: TitlePreviewViewModel)
}

class ColletionViewTableViewCell: UITableViewCell {
    static let identifier = "ColletionViewTableViewCell"
    
    private var titles: [Title] = [Title]()
    
    
    weak var delegate: ColletionViewTableViewCellDelegate?
    
    
    private let colletionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleColletionViewCell.self, forCellWithReuseIdentifier: TitleColletionViewCell.identifier)
        return collectionView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = .systemPink
        self.contentView.addSubview(colletionView)
        
    
        self.colletionView.delegate = self
        self.colletionView.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        colletionView.frame = contentView.bounds
    }
    
  
    public func configure(with titles: [Title]){
        self.titles = titles
        
        DispatchQueue.main.async  { [weak self] in 
            self?.colletionView.reloadData()
        }
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension ColletionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleColletionViewCell.identifier, for: indexPath) as? TitleColletionViewCell else {
            
            return UICollectionViewCell()
            
        }
        
        
        guard let model = titles[indexPath.row].poster_path else {
            return UICollectionViewCell()

        }
        
        
        cell.configure(with: model)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_name ?? title.original_title else {
            return
        }
        
        
        APICaller.shared.getMovie(with: titleName + "trailer"){
            [weak self] result in
            switch result{
            case .success(let videoElement):
                let title = self? .titles[indexPath.row]
                guard let titleOverview = title?.overview else {
                    return
                }
                
                guard let strongSelf = self else { return }
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
                self?.delegate?.colletionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
            case .failure(let error):
                print("error")
            
                print(error.localizedDescription)
            }
        }
        
    }
    
}
