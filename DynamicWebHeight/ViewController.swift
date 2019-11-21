//
//  ViewController.swift
//  DynamicWebHeight
//
//  Created by Afriyandi Setiawan on 21/11/19.
//  Copyright © 2019 Afriyandi Setiawan. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var bottomEdge: NSLayoutConstraint!
    private var webHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(UIScreen.main.bounds.height)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        buttonContainer.frame = CGRect(origin: CGPoint(x: 0, y: UIScreen.main.bounds.height), size: buttonContainer.frame.size)
        let link = URL(string:"https://www.cizzu.com/2019/08/03/cocoapod-caching-mengurangi-build-time-circleci/")!
        let request = URLRequest(url: link)
        webView.load(request)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("offset: \(scrollView.contentOffset.y)")
        guard let webHeight = webHeight else {
            return
        }
        print("web height: \(webHeight)")
        let realHeight = webHeight - self.webView.frame.height
        print("real height: \(realHeight)")
        if scrollView.contentOffset.y >= realHeight - buttonContainer.frame.height {
            UIView.animate(withDuration: 0.2) {
                self.bottomEdge.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    if let height = height as? CGFloat {
                        self.webHeight = height
                    }
                })
            }
            
        })
    }
}
