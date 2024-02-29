//
//  FollowerCell.swift
//  GHFollowers
//
//  Created by Maryna Bolotska on 24/02/24.
//

import UIKit
//protocol FollowerCellModel {
//    var text: String? { get }
//}
//
//extension FollowerCellModel {
//    var text: String? { nil }
//    
//}
class FollowerCell: UICollectionViewCell {
    static let reuseID = "FollowerCell"

    let avatarImageView = GFAvatarImageView(frame: .zero)
    let usernameLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)


    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(follower: Follower) {
        usernameLabel.text = follower.login
        NetworkManager.shared.downloadImage(from: follower.avatarUrl) { [weak self] image in
                    guard let self = self else { return }
                    DispatchQueue.main.async { self.avatarImageView.image = image }
                }
    }

    private func configure() {
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        
        let padding: CGFloat = 10
        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            avatarImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            usernameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            usernameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
    }


}
