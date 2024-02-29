//
//  UITableView+Ext.swift
//  GHFollowers
//
//  Created by Maryna Bolotska on 29/02/24.
//

import UIKit
extension UITableView {

    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }

   
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
        tableFooterView = UIView(frame: .zero)
    }
    
    }
