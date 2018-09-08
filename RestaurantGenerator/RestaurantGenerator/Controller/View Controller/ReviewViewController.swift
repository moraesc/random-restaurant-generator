//
//  ReviewWebPage.swift
//  RestaurantGenerator
//
//  Created by Camilla Moraes on 8/6/18.
//  Copyright © 2018 Camilla Moraes. All rights reserved.
//

import UIKit
import WebKit

class ReviewViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var reviewURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let myUrl = URL(string: "\(reviewURL ?? "")") else { return }
        let urlRequest = URLRequest(url: myUrl)
        webView.load(urlRequest)
        
        self.navItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backPressed))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func backPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
}
