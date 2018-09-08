//
//  UIViewExtension.swift
//  RestaurantGenerator
//
//  Created by Camilla Moraes on 8/13/18.
//  Copyright © 2018 Camilla Moraes. All rights reserved.
//

import UIKit

extension UIView {
    func anchor(view: UIView) {
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
}
