//
//  WebViewController.swift
//  WKWebViewExample
//
//  Created by Charlie on 26/10/2018.
//  Copyright © 2017 Charlie. All rights reserved.  MIT License.
//

import UIKit
import WebKit
import Lottie

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webViewController = WebViewController()
        
        // install the WebViewController as a child view controller
        addChild(webViewController)
        
        let webViewControllerView = webViewController.view!
        
        view.addSubview(webViewControllerView)
        
        webViewControllerView.translatesAutoresizingMaskIntoConstraints = false
        webViewControllerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webViewControllerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webViewControllerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webViewControllerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        webViewController.didMove(toParent: self)
        
        
    }
}

class WebViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    private var webView: WKWebView!
    private var webViewContentIsLoaded = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.webView = {
            let contentController = WKUserContentController()
            
            contentController.add(self, name: "WebViewControllerMessageHandler")
            
            let configuration = WKWebViewConfiguration()
            configuration.userContentController = contentController
            
            let webView = WKWebView(frame: .zero, configuration: configuration)
            webView.scrollView.bounces = false
            webView.navigationDelegate = self
            
            return webView
        }()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        setWebViewAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !webViewContentIsLoaded {
            let url = URL(string: "https://www.jiguang.cn/")!//"https://google.com")!//
            let request = URLRequest(url: url)
            
            webView.load(request)
            
            webViewContentIsLoaded = true
        }
    }
    
    private func evaluateJavascript(_ javascript: String, sourceURL: String? = nil, completion: ((_ error: String?) -> Void)? = nil) {
        var javascript = javascript
        
        // Adding a sourceURL comment makes the javascript source visible when debugging the simulator via Safari in Mac OS
        if let sourceURL = sourceURL {
            javascript = "//# sourceURL=\(sourceURL).js\n" + javascript
        }
        
        webView.evaluateJavaScript(javascript) { _, error in
            completion?(error?.localizedDescription)
        }
    }
    
    //lottie
    var data_ = Data()
    var buttonBlock = UIButton()
    var isShowCover_: Bool = false
    let animationView_1 = LOTAnimationView(name: "prathikfav") //loading //glow_loading //fish // fireworks //infinite_rainbow // loading_morphing // loadin //heartrate // zoom_when_loading_data // loading_-_logo_reveal // me_at_office // prathikfav
    
    
    func setWebViewAnimation() {
        
        let height = view.frame.width * (3 / 2)
        let centerY = (view.frame.height - view.frame.width * (3 / 2)) / 2
        animationView_1.frame = CGRect(x: 0 , y: centerY , width: view.frame.width , height: height)

        animationView_1.backgroundColor = .black //.clear //.black
        animationView_1.play()
        animationView_1.loopAnimation = true
        
        webView.backgroundColor = .black
//        let sublayers = view.layer.sublayers!
//        print("sublayers.count = \(sublayers.count)")
//        animationView_1.layer.zPosition = CGFloat(sublayers.count + 1)
//        animationView_1.frame = view.frame
        webView.addSubview(animationView_1)
//

        
//        Lottie official example
//        let animationView = LOTAnimationView(name: "LottieLogo")
//        self.view.addSubview(animationView)
//        animationView.play{ (finished) in
//            // Do Something
//        }

    }
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // This must be valid javascript!  Critically don't forget to terminate statements with either a newline or semicolon!
        let javascript =
            "var outerHTML = document.documentElement.outerHTML.toString()\n" +
                "var message = {\"type\": \"outerHTML\", \"outerHTML\": outerHTML }\n" +
        "window.webkit.messageHandlers.WebViewControllerMessageHandler.postMessage(message)\n"
        
        evaluateJavascript(javascript, sourceURL: "getOuterHMTL")
        print("WebView didFinish")
        animationView_1.isHidden = true
    }
    
    // MARK: - WKScriptMessageHandler
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let body = message.body as? [String: Any] else {
            print("could not convert message body to dictionary: \(message.body)")
            return
        }
        
        guard let type = body["type"] as? String else {
            print("could not convert body[\"type\"] to string: \(body)")
            return
        }
        
        switch type {
        case "outerHTML":
            guard let outerHTML = body["outerHTML"] as? String else {
                print("could not convert body[\"outerHTML\"] to string: \(body)")
                return
            }
//            print("outerHTML is \(outerHTML)")
            print("outerHTML close")
            animationView_1.isHidden = true
        default:
            print("unknown message type \(type)")
            return
        }
    }
}
