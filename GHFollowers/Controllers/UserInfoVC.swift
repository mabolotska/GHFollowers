//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Maryna Bolotska on 25/02/24.
//

import UIKit

protocol UserInfoVCDelegate: AnyObject {
    func didTapGithubProfile(for user: User)
      func didTapGetFollowers(for user: User)
}


class UserInfoVC: UIViewController {
    weak var delegate: FollowerListVCDelegate!
    var username: String!
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    
    var itemViews: [UIView] = []
    let dateLabel = GFBodyLabel(textAlignment: .center)
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        layoutUI()
        configureViewController()
        getUserInfo()
   
    }
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
//               self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
//               self.add(childVC: GFRepoItemVC(user: user), to: self.itemViewOne)
//               self.add(childVC: GFFollowerItemVC(user: user), to: self.itemViewTwo)
//               self.dateLabel.text = "GitHub since " + user.createdAt.convertToDisplayFormat()
                    self.configureUIElements(with: user)
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "something went wrong", message: error.rawValue, buttonTitle: "ok")
            }
        }
    }
    
    func configureUIElements(with user: User) {
          // declares the delegates before adding the view
          let repoItemVC = GFRepoItemVC(user: user)
          repoItemVC.delegate = self

          let followerItemVC = GFFollowerItemVC(user: user)
          followerItemVC.delegate = self

          self.add(childVC: repoItemVC, to: self.itemViewOne)
          self.add(childVC: followerItemVC, to: self.itemViewTwo)
          self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
          self.dateLabel.text = "GitHub since " + user.createdAt.convertToDisplayFormat()
      }
    
    func layoutUI() {
//            view.addSubview(headerView)
//            view.addSubview(itemViewOne)
//            view.addSubview(itemViewTwo)
//
//               itemViewOne.backgroundColor = .systemPink
//               itemViewTwo.backgroundColor = .systemBlue
//
//               itemViewOne.translatesAutoresizingMaskIntoConstraints = false
//               itemViewTwo.translatesAutoresizingMaskIntoConstraints = false
//
//            headerView.translatesAutoresizingMaskIntoConstraints = false
        
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -padding),
            ])
        }
        
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
         
        }

        // this is how to add a child view controller programmatically
        func add(childVC: UIViewController, to containerView: UIView) {
            addChild(childVC)
            containerView.addSubview(childVC.view)
            childVC.view.frame = containerView.bounds // vc to fill up whole view controller
            childVC.didMove(toParent: self)
        }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}


extension UserInfoVC: UserInfoVCDelegate {
    func didTapGithubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
                  presentGFAlertOnMainThread(title: "Invalid URL", message: "The url attached to this user is invalid", buttonTitle: "OK")
                  return
              }
              presentSafariVC(url: url)
    }
    
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else {
           
                 presentGFAlertOnMainThread(title: "No followers", message: "This user has no followers", buttonTitle: "Ok")
                 return
             }

             delegate.didRequestFollowers(for: user.login)
             dismissVC()
    }
    
 


}
