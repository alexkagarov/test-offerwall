//
//  WebPageViewController.swift
//  test-offerwall
//
//  Created by Alex Kagarov on 6/11/19.
//  Copyright © 2019 Alex Kagarov. All rights reserved.
//

import UIKit
import WebKit

class WebPageViewController: UIViewController, WKNavigationDelegate {
    
    @IBAction func onRestoreDefaults(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.set(0, forKey: "ResponseState")
        navigationController?.popToRootViewController(animated: true)
    }
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        let url = URL(string: "https://html5test.com/")!
        webView.load(URLRequest(url: url))
    }
}
