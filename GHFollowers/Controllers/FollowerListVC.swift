//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Maryna Bolotska on 23/02/24.
//

import UIKit

protocol FollowerListVCDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}



class FollowerListVC: UIViewController {
    enum Section {
        case main
    }
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        configureCollectionView()
        configureViewController()
        getFollowers(username: username, page: page)
        configureDataSource()
        configureSearchController()
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
        showLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else {return } // i use it to avoid using of self?.followers
            
            self.dismissLoadingView() //to hide loading view
            switch result {
            case .success(let followers):
                
                if followers.count < 100 { self.hasMoreFollowers = false }
                            self.followers.append(contentsOf: followers)
                
                
                if self.followers.isEmpty {
                                  let message = "This user doesn't have any followers"

                                  DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
                                  return
                              }
                
                
           //     self.followers = followers
                self.updateData(on: self.followers)
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
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    func configureSearchController() {
          let searchController = UISearchController()
          searchController.searchResultsUpdater = self
          searchController.searchBar.delegate = self
          searchController.searchBar.placeholder = "Search for a username"
          searchController.obscuresBackgroundDuringPresentation = false // removes light overlay on results below
          navigationItem.searchController = searchController

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
    
    // to know when  collection view item is selected
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           // clever way to aleternate on an array
           let activeArray = isSearching ? filteredFollowers : followers
           let follower = activeArray[indexPath.item]

           let destVC = UserInfoVC()
          
           destVC.username = follower.login
           destVC.delegate = self
            let navController = UINavigationController(rootViewController: destVC) // gives you the top bar
            present(navController, animated: true)
        
       }
}

/// lets you know the search query has changed
extension FollowerListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // make sure have text
        guard let filter = searchController.searchBar.text, filter.isEmpty == false else { return }
        
        isSearching = true
        // uses two arrays to control which array to show at a given moment
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
}

extension FollowerListVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
         updateData(on: followers)
    }
}

extension FollowerListVC: FollowerListVCDelegate {
    func didRequestFollowers(for username: String) {
        // get folllowers for that user
        self.username = username
        title = username
        page = 1
        followers.removeAll()
        collectionView.setContentOffset(.zero, animated: true)
        getFollowers(username: username, page: page)
    }
}
