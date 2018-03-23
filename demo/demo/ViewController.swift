//
//  ViewController.swift
//  demo
//
//  Created by Vincent on 22/03/2018.
//  Copyright © 2018 Vincent. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    lazy fileprivate var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        // add js listener
        config.userContentController.add(self, name: "callbackHandler")
        // 加载过程中，通过注入调用JS(只能在页面加载之前注入)
        let script = WKUserScript(source: "changeHeaderColor()", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        config.userContentController.addUserScript(script)
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        webView.frame = view.bounds
        view.sendSubview(toBack: webView)
        
        loadLocalHTML()
    }
    
    /// 调用JS
    @IBAction private func changeHeaderColorButtonClick() {
        // 直接调用
        webView.evaluateJavaScript("changeHeaderColor()") { (a, b) in
            print(#function)
        }
    }
}

fileprivate extension ViewController {
    
    func loadLocalHTML() {
        if let url = Bundle.main.url(forResource: "local", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url)
            print(url.absoluteString)
        }
    }
}

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "callbackHandler" {
            let alert = UIAlertController(title: "Message from JS received!", message: "Content: \(message.body)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

