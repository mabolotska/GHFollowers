//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Maryna Bolotska on 23/02/24.
//

import UIKit

class FollowerListVC: UIViewController {
    enum Section {
        case main
    }
    var followers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureCollectionView()
        configureViewController()
        getFollowers(username: username, page: page)
        configureDataSource()
    }
    
    func configureDataSource() {
            dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: {(collectionView, indexPath,follower) -> UICollectionViewCell? in
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as? FollowerCell
         cell?.set(follower: follower)
         return cell
     })
 }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true) // shows animation instead of just hiding it
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    func getFollowers(username: String, page: Int) {
        //        NetworkManager.shared.getFollowers(for: username, page: 1) {(followers, errorMessage) in
        //            guard let followers = followers else {
        //                self.presentGFAlertOnMainThread(title: "Bad stuff", message: errorMessage!.rawValue, buttonTitle: "OK")
        //                return
        //            }
        //            print("Followers.count = \(followers.count)")
        //            print(followers)
        //
        //        }
        
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else {return } // i use it to avoid using of self?.followers
            switch result {
            case .success(let followers):
                
                if followers.count < 100 { self.hasMoreFollowers = false }
                            self.followers.append(contentsOf: followers)
                
                self.followers = followers
                self.updateData()
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad stuff", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    
    

    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
}


extension FollowerListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        print("offset: \(offsetY)")
        print("contentheight: \(contentHeight)")
        print("height: \(height)")

        if offsetY > contentHeight - height {
            guard hasMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
}
