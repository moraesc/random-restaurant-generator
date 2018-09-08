//
//  GenerateButton.swift
//  RestaurantGenerator
//
//  Created by Camilla Moraes on 7/30/18.
//  Copyright © 2018 Camilla Moraes. All rights reserved.
//

import UIKit

class GenerateButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setButtonProperties()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setButtonProperties()
    }
    
    func setButtonProperties() {
        setTitleColor(UIColor.newPink, for: .normal)
        titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 25)
        layer.borderColor = UIColor.newGray.cgColor
        layer.borderWidth = 2
        backgroundColor = .white
        layer.cornerRadius = 36
    }
    
}
