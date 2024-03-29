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



class FollowerListVC: GFDataLoadingVC {
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
    var isLoadingMoreFollowers = false
    
    //to use in didSelectRowAt destVC to navigate
    init(username: String) {
          super.init(nibName: nil, bundle: nil)
          self.username = username
          title = username
      }

      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    
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
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
               navigationItem.rightBarButtonItem = addButton
    }
    func getFollowers(username: String, page: Int) {
        isLoadingMoreFollowers = true
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
                self.isLoadingMoreFollowers = false
            }
        }
        
        
    }
    
    @objc func addButtonTapped() {
        showLoadingView()
              NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
                  guard let self = self else { return }
                  self.dismissLoadingView()

                  switch result {
                  case .success(let user):
                      let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                      PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
                          guard let self = self else { return }
                          guard let error = error else {
                              self.presentGFAlertOnMainThread(title: "Success!", message: "You have successfully favorited this user", buttonTitle: "Ok")
                              return
                          }

                          self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                      }
                  case .failure(let error):
                      self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
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
            guard hasMoreFollowers, isLoadingMoreFollowers == false else { return }
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
        guard let filter = searchController.searchBar.text, filter.isEmpty == false else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        
        isSearching = true
        // uses two arrays to control which array to show at a given moment
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
}



extension FollowerListVC: FollowerListVCDelegate {
    func didRequestFollowers(for username: String) {
        // get folllowers for that user
        self.username = username
        title = username
        page = 1
        followers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: page)
    }
}
