//
//  HeroHeaderUIView.swift
//  Netflix Clone
//
//  Created by Jackson Matheus on 18/03/23.
//

import UIKit

class HeroHeaderUIView:UIView {
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let  heroImageView: UIImageView = {
        let image = UIImageView()
        
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = UIImage(named: "heroImage")
        
        return image
    }()
    
    
    
    private func addGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor,
        ]
        gradientLayer.frame = bounds
        
        self.layer.addSublayer(gradientLayer)
    }
    
    private func applyConstraint(){
        let playButtonConstraint = [
            playButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        
        let downloadButtonConstraint = [
            downloadButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        NSLayoutConstraint.activate(playButtonConstraint)
        NSLayoutConstraint.activate(downloadButtonConstraint)

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.addSubview(heroImageView)
        addGradient()
        
        self.addSubview(playButton)
        self.addSubview(downloadButton)
        applyConstraint()
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        heroImageView.frame = bounds
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    
}

