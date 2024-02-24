//
//  GFBodyLabel.swift
//  GHFollowers
//
//  Created by Maryna Bolotska on 24/02/24.
//

import UIKit

final class GFBodyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(textAlignment: NSTextAlignment) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        configure()
    }
    
    private func configure() {
        textColor = .label
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth = true // shrink a bit to try to fit into the label
        minimumScaleFactor = 0.75
        lineBreakMode = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }

}
