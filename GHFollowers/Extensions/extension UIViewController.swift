//
//  extension UIViewController.swift
//  GHFollowers
//
//  Created by Maryna Bolotska on 24/02/24.
//

import UIKit

extension UIViewController {
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen // avoids card style in iOS 13
            alertVC.modalTransitionStyle = .crossDissolve // fades in
            self.present(alertVC, animated: true)
        }
    }
}

