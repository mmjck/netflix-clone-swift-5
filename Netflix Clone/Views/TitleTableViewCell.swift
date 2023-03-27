//
//  TitleTableViewCell.swift
//  Netflix Clone
//
//  Created by Jackson Matheus on 22/03/23.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    static let identifier: String = "TitleTableViewCell"
    
    
    private let titlePosterUIImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true

        return image
    }()
    
    
    private let playTitleButton: UIButton = {
        let button = UIButton()
        
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        self.contentView.addSubview(titlePosterUIImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(playTitleButton)
        
        applyConstraint()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    
    private func applyConstraint() {
        let titlePosterUIImageViewConstraints = [
            titlePosterUIImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            titlePosterUIImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            
            titlePosterUIImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            titlePosterUIImageView.widthAnchor.constraint(equalToConstant: 100),
        ]
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: self.titlePosterUIImageView.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
        ]
        
        
        let playTitleButtonConstraints = [
            playTitleButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            playTitleButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(titlePosterUIImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(playTitleButtonConstraints)
    }
    
    
    public func configure(with model: TitleViewModel){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {
                  return
        }
        
        
        titlePosterUIImageView.sd_setImage(with: url, completed: nil)
        titleLabel.text = model.titleName
        
    }
}
