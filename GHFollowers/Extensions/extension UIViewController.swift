//
//  extension UIViewController.swift
//  GHFollowers
//
//  Created by Maryna Bolotska on 24/02/24.
//

import UIKit
import SafariServices

//fileprivate var containerView: UIView! i moved these functions below to DataLoadingVC

extension UIViewController {
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen // avoids card style in iOS 13
            alertVC.modalTransitionStyle = .crossDissolve // fades in
            self.present(alertVC, animated: true)
        }
    }
    
//    func showLoadingView() {
//            containerView = UIView(frame: view.bounds)
//            view.addSubview(containerView)
//
//            containerView.backgroundColor = .systemBackground
//            containerView.alpha = 0
//
//            UIView.animate(withDuration: 0.25) {
//                containerView.alpha = 0.8
//            }
//
//            let activityIndicator = UIActivityIndicatorView(style: .large)
//            containerView.addSubview(activityIndicator)
//
//            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//
//            NSLayoutConstraint.activate([
//                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//            ])
//            activityIndicator.startAnimating()
//        }
//
//        func dismissLoadingView() {
//            DispatchQueue.main.async {
//                containerView.removeFromSuperview()
//                containerView = nil
//            }
//        }
//    
//    func showEmptyStateView(with message: String, in view: UIView) {
//          let emptyStateView = GFEmptyStateView(message: message)
//          emptyStateView.frame = view.bounds
//          view.addSubview(emptyStateView)
//      }
//    
    func presentSafariVC(url: URL) {
          let safariVC = SFSafariViewController(url: url)
          safariVC.preferredControlTintColor = .systemGreen
          present(safariVC, animated: true)
      }
}

