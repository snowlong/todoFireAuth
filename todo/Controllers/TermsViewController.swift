//
//  TermsViewController.swift
//  todo
//
//  Created by Jun Takahashi on 2019/05/29.
//  Copyright © 2019 Jun Takahashi. All rights reserved.
//

import UIKit
import WebKit

class TermsViewController: UIViewController {

    @IBOutlet weak var termsWebView: WKWebView!
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        self.configureWebView()
    }
    
    @IBAction func closeTappedBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //WebViewにリフレッシュコントロールをつけてみる
    func configureWebView(){
        let myURL = URL(string: "https://www.google.com/")
        let myRequest = URLRequest(url: myURL!)
        self.termsWebView.uiDelegate = self
        self.termsWebView.navigationDelegate = self
        self.termsWebView.load(myRequest)
        self.termsWebView.scrollView.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(self.refreshWebView(sender:)), for: .valueChanged)
    }
    
    @objc func refreshWebView(sender: UIRefreshControl) {
        self.termsWebView.reload()
        sender.endRefreshing()
    }
    
}

//新しいウィンドウを開いたり、クリックして表示されるものの動作を補足したりする
extension TermsViewController : WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}

//遷移や読み込みの開始・完了・エラーなどを受け取りたい場合はこれを使う
extension TermsViewController : WKNavigationDelegate{
    
func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    print("WebビューがWebコンテンツの受信を開始したときに呼ばれる")
}
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("ナビゲーション中にエラーがでたときに呼ばれる")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("ナビゲーションが完了したときに呼ばれる")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Webのロード完了後に実行されるメソッド")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            webView.takeSnapshot(with: nil) { (image, error) in
                print(image) //スクショ
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("ナビゲーションを許可するかキャンセルするかを決定")
        decisionHandler(WKNavigationActionPolicy.allow) // これないとクラッシュ
    }

}
