//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Maryna Bolotska on 23/02/24.
//

import UIKit

class FollowerListVC: UIViewController {
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        //        NetworkManager.shared.getFollowers(for: username, page: 1) {(followers, errorMessage) in
        //            guard let followers = followers else {
        //                self.presentGFAlertOnMainThread(title: "Bad stuff", message: errorMessage!.rawValue, buttonTitle: "OK")
        //                return
        //            }
        //            print("Followers.count = \(followers.count)")
        //            print(followers)
        //
        //        }
        
        NetworkManager.shared.getFollowers(for: username, page: 1) { result in
            switch result {
            case .success(let followers):
                print("Followers.count = \(followers.count)")
                print(followers)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad stuff", message: error.rawValue, buttonTitle: "OK")
            }
            
           
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
