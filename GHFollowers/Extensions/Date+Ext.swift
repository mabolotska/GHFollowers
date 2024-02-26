//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Maryna Bolotska on 26/02/24.
//

import Foundation
extension Date {
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
