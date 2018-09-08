//
//  SelectLocationView.swift
//  RestaurantGenerator
//
//  Created by Camilla Moraes on 7/30/18.
//  Copyright © 2018 Camilla Moraes. All rights reserved.
//

import UIKit

class SelectLocationView: UIView, CustomButtonDelegate {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var selectLocationLabel: UILabel!
    @IBOutlet weak var uptownButton: CustomButton!
    @IBOutlet weak var downtownButton: CustomButton!
    @IBOutlet weak var midtownButton: CustomButton!
    @IBOutlet weak var noPreferenceButton: CustomButton!
    
    var locationButtonValue: String?
    lazy var buttonArray: [CustomButton] = {
        return [uptownButton, downtownButton, midtownButton, noPreferenceButton]
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed("SelectLocationView", owner: self, options: nil)
        self.addSubview(contentView)
        setButtons()
        setButtonDelegates()        
    }
    
    func setButtons() {
        uptownButton.setTitle("Uptown", for: .normal)
        downtownButton.setTitle("Downtown", for: .normal)
        midtownButton.setTitle("Midtown", for: .normal)
        noPreferenceButton.setTitle("No Preference", for: .normal)
    }
    
    func setButtonDelegates() {
        uptownButton.delegate = self
        downtownButton.delegate = self
        midtownButton.delegate = self
        noPreferenceButton.delegate = self
    }
    
    func resetButtonState() {
        for button in buttonArray {
            button.isSelected = false
            button.backgroundColor = .white
            button.setTitleColor(UIColor(red: 206/255, green: 99/255, blue: 99/255, alpha: 1.0), for: .normal)
        }
    }
    
    func buttonClicked(button: CustomButton) {
        
        locationButtonValue = button.titleLabel?.text
        
        let alreadySelectedButton = button.isSelected == true
        
        resetButtonState()
        
        //update button state of selected button
        if !alreadySelectedButton {
            button.isSelected = true
            button.backgroundColor = UIColor(red: 206/255, green: 99/255, blue: 99/255, alpha: 1.0)
            button.setTitleColor(.white, for: .normal)
        }
        
    }
    
}
