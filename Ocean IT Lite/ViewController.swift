//
//  ViewController.swift
//  Ocean IT Lite
//
//  Created by hoseoict on 2020/06/30.
//  Copyright © 2020 Ocean IT. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var oceanLink = "http://ec2-15-164-231-37.ap-northeast-2.compute.amazonaws.com:8080/"
    var link = ["deviceMain.do", "deviceManagement.do", "deviceLog.do"]
    
    @IBOutlet weak var pagecontrol: UIPageControl!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
            pagecontrol.numberOfPages = link.count
            pagecontrol.currentPage = 0
            pagecontrol.pageIndicatorTintColor = UIColor.gray
            pagecontrol.currentPageIndicatorTintColor = UIColor.black
            self.request(url: oceanLink + link[0])
            
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.respondToSwipeGesture(_:)))
            swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
            self.view.addGestureRecognizer(swipeLeft)
            
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.respondToSwipeGesture(_:)))
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            self.view.addGestureRecognizer(swipeRight)
        }
        
        @objc func respondToSwipeGesture(_ gesture: UISwipeGestureRecognizer)
        {
            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                
                switch swipeGesture.direction {
                case UISwipeGestureRecognizer.Direction.left:
                    pagecontrol.currentPage -= 1
                    request(url: oceanLink + link[pagecontrol.currentPage])
                case UISwipeGestureRecognizer.Direction.right:
                    pagecontrol.currentPage += 1
                    request(url: oceanLink + link[pagecontrol.currentPage])
                default:
                    break
                }
            }

    }
    @IBAction func stop(_ sender: UIBarButtonItem) {
         self.webView.stopLoading()
    }
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        self.webView.reload()
    }
    @IBAction func back(_ sender: UIBarButtonItem) {
        if self.webView.canGoBack{
               pagecontrol.currentPage -= 1
               self.webView.goBack()
           }
    }
    @IBAction func foreward(_ sender: UIBarButtonItem) {
        if self.webView.canGoForward{
            pagecontrol.currentPage += 1
            self.webView.goForward()
        }
    }
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        request(url: oceanLink + link[pagecontrol.currentPage])
    }
    
    func request(url: String)
    {
        self.webView.load(URLRequest(url: URL(string: url)!))
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.color = UIColor.red
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @available(iOS 8.0, *)
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let otherAction = UIAlertAction(title: "OK", style: .default, handler: {action in completionHandler()})
        alert.addAction(otherAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @available(iOS 8.0, *)
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Swift.Void){
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: {(action) in completionHandler(false)})
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {(action) in completionHandler(true)})
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    
}

