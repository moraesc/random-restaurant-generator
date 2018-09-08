//
//  Button.swift
//  RestaurantGenerator
//
//  Created by Camilla Moraes on 7/27/18.
//  Copyright © 2018 Camilla Moraes. All rights reserved.
//

import UIKit

protocol CustomButtonDelegate: class {
    func buttonClicked(button: CustomButton)
}

class CustomButton: UIButton {
    
    weak var delegate: CustomButtonDelegate?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setButtonProperties()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setButtonProperties()
    }
    
    func setButtonProperties() {
            backgroundColor = .white
            setTitleColor(UIColor.newPink, for: .normal)
            titleLabel?.font = UIFont(name: "Avenir-Medium", size: 17)
            layer.borderColor = UIColor.newGray.cgColor
            layer.borderWidth = 2
            self.addTarget(self, action: #selector(changeBackground), for: .touchUpInside)
    }
    
    @objc func changeBackground() {
        delegate?.buttonClicked(button: self)
    }
    
}
