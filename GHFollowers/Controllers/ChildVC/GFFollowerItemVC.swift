//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by Maryna Bolotska on 26/02/24.
//

import UIKit

class GFFollowerItemVC: GFItemInfoVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }

    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
        }

    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
}
