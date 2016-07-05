//
//  DetailViewController.swift
//  Penti
//
//  Created by mcxiaoke on 16/6/30.
//  Copyright © 2016年 mcxiaoke. All rights reserved.
//

import UIKit
import WebKit
import PureLayout
import MBProgressHUD

class DetailViewController: UIViewController {

  var item:FeedItem?
  var webView:WKWebView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpWebView()
    self.title = "\(item?.id ?? 0)"
    if let url = item?.url {
      webView?.loadRequest(NSURLRequest(URL: url))
    }
    let hud =  MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    hud.color = Colors.mainColor
    hud.animationType = .Fade
  }
  
  func setUpWebView(){
    let userContentController = WKUserContentController()
    userContentController.addJavaScript("style")
    userContentController.addJavaScript("content")
    userContentController.addScriptMessageHandler(self, name: "bridge")
    let configuration = WKWebViewConfiguration()
    configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
    configuration.userContentController = userContentController
    let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
    webView.hidden = true
    webView.navigationDelegate = self
    webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
    self.view.addSubview(webView)
    webView.autoPinEdgesToSuperviewEdges()
    self.webView = webView
  }
  
  override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    guard let object = object as? WKWebView else { return }
    guard let keyPath = keyPath else { return }
    if keyPath == "estimatedProgress" && object == webView {
      if webView?.estimatedProgress == 1.0 {
        print("estimatedProgress = 100%")
      }
    }
  }

}

extension WKUserContentController {
  func addJavaScript(fileName: String){
    let jsPath = NSBundle.mainBundle().pathForResource(fileName, ofType: "js")
    let jsSource = try! String(contentsOfFile: jsPath!, encoding: NSUTF8StringEncoding)
    let userScript = WKUserScript(source: jsSource, injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
    addUserScript(userScript)
  }
}

extension DetailViewController: WKNavigationDelegate {
  func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
    print("didFinishNavigation")
    MBProgressHUD.hideHUDForView(self.view, animated: true)
    self.webView?.hidden = false
  }
}

extension DetailViewController: WKScriptMessageHandler {
  func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
    print(message.body)
  }
}
