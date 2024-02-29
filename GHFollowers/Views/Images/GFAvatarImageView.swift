//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Maryna Bolotska on 25/02/24.
//

import UIKit

class GFAvatarImageView: UIImageView {
    let cache = NetworkManager.shared.cache
    
    let placeHolderImage = UIImage(named: "avatar-placeholder")
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true // sets the image to not have sharp corners in addition to the layer corner radius
        image = placeHolderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
   
}
