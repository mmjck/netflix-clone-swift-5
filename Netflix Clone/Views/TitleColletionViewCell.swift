//
//  TitleColletionView.swift
//  Netflix Clone
//
//  Created by Jackson Matheus on 20/03/23.
//

import UIKit
import SDWebImage


class TitleColletionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleColletionViewCell"
    
    
    private let posterImageView : UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(posterImageView)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        posterImageView.frame = self.contentView.bounds
    }
    
    
    public func configure(with model: String){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {
                  return
        }
        posterImageView.sd_setImage(with: url, completed: nil)

    }
}
