//
//  ViewController.swift
//  SimpleBrowser
//
//  Created by SoHirai on 2016/03/14.
//  Copyright © 2016年 SoHirai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var stopButton: UIBarButtonItem!

    // initial homepage
    let homeUrl = "http://www.yahoo.co.jp"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // view homepage
        openUrl(homeUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // open url with web view
    func openUrl(urlString: String){
        let url = NSURL(string: urlString)
        let urlRequest = NSURLRequest(URL: url!)
        webView.loadRequest(urlRequest)
    }

    @IBAction func backButtonTapped(sender: UIBarButtonItem) {
    }

    @IBAction func reloadButtonTapped(sender: UIBarButtonItem) {
    }
    
    @IBAction func stopButtonTapped(sender: UIBarButtonItem) {
    }
    
    
    
}

