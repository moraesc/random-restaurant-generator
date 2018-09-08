//
//  SelectCuisineView.swift
//  RestaurantGenerator
//
//  Created by Camilla Moraes on 7/30/18.
//  Copyright © 2018 Camilla Moraes. All rights reserved.
//

import UIKit

class SelectMealTypeView: UIView, CustomButtonDelegate {
    
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var americanButton: CustomButton!
    @IBOutlet weak var asianButton: CustomButton!
    @IBOutlet weak var mexicanButton: CustomButton!
    @IBOutlet weak var italianButton: CustomButton!
    
    var cuisineButtonValue: String?
    lazy var buttonArray: [CustomButton] = {
        return [americanButton, asianButton, mexicanButton, italianButton]
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
        bundle.loadNibNamed("SelectMealTypeView", owner: self, options: nil)
        anchor(view: contentView)
        setButtons()
    }
    
    func setButtons() {
        americanButton.setTitle("American", for: .normal)
        asianButton.setTitle("Asian", for: .normal)
        mexicanButton.setTitle("Mexican", for: .normal)
        italianButton.setTitle("Italian", for: .normal)
        
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
        
        cuisineButtonValue = button.titleLabel?.text
        
        let alreadySelectedButton = button.isSelected == true
        
        resetButtonState()
        
        //update button state of selected button
        if !alreadySelectedButton {
            button.isSelected = true
            button.backgroundColor = UIColor.newPink
            button.setTitleColor(.white, for: .normal)
        }
    }

}

