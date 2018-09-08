//
//  SearchLocationView.swift
//  RestaurantGenerator
//
//  Created by Camilla Moraes on 8/2/18.
//  Copyright © 2018 Camilla Moraes. All rights reserved.
//

import UIKit

class SearchLocationView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    
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
        bundle.loadNibNamed("SearchLocationView", owner: self, options: nil)
        anchor(view: contentView)
        contentView.layer.cornerRadius = 20
    }
    
}
