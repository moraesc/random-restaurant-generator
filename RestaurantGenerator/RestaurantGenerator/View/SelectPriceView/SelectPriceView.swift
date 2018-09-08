//
//  SelectPriveView.swift
//  RestaurantGenerator
//
//  Created by Camilla Moraes on 8/6/18.
//  Copyright © 2018 Camilla Moraes. All rights reserved.
//

import UIKit

class SelectPriceView: UIView, CustomButtonDelegate {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var selectPriceLabel: UILabel!
    @IBOutlet weak var lowPriceButton: CustomButton!
    @IBOutlet weak var mediumPriceButton: CustomButton!
    @IBOutlet weak var expensivePriceButton: CustomButton!
    
    var priceButtonValue: String?
    lazy var buttonArray: [CustomButton] = {
        return [lowPriceButton, mediumPriceButton, expensivePriceButton]
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed("SelectPriceView", owner: self, options: nil)
        anchor(view: contentView)
        setupButtons()
    }
    
    func setupButtons() {
        lowPriceButton.setTitle("$", for: .normal)
        mediumPriceButton.setTitle("$$", for: .normal)
        expensivePriceButton.setTitle("$$$", for: .normal)
        
        for button in buttonArray {
            button.layer.cornerRadius = 20
            button.delegate = self
        }
    }

    func resetButtonState() {
        for button in buttonArray {
            button.isSelected = false
            button.backgroundColor = .white
            button.setTitleColor(UIColor.newPink, for: .normal)
        }
    }
    
    func buttonClicked(button: CustomButton) {
        priceButtonValue = button.titleLabel?.text
        
        let alreadySelectedButton = button.isSelected == true
        
        resetButtonState()
        
        if !alreadySelectedButton {
            button.isSelected = true
            button.backgroundColor = UIColor.newPink
            button.setTitleColor(.white, for: .normal)
        }
    }
    
}
