//
//  FavoriteListVC.swift
//  GHFollowers
//
//  Created by Maryna Bolotska on 23/02/24.
//

import UIKit

class FavoriteListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

}
