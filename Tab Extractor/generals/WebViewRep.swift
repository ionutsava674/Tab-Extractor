//
//  WebViewRep.swift
//  Tab Extractor
//
//  Created by Ionut on 30.05.2021.
//

import SwiftUI
import WebKit

struct SwiftUIWebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    typealias OnFinishNavigationCallback = (String, String?) -> Void
    class WKNav:NSObject, WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate {
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            //print("mhr")
            if let m = message.body as? String {
                //print("mh \(m.count)")
            }
        }
        
        var parent: SwiftUIWebView
        init( parent: SwiftUIWebView) {
            self.parent = parent
        }
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // print(webView.url?.absoluteString ?? "no url")
            if let daddr = webView.url?.absoluteString {
                parent.cc.addr = daddr
                parent.targetAddr = daddr
            }
                let jsBody = "document.body.innerText"
            let jsTitle = "document.title"
            //let jss = "document.body.textContent"
            webView.evaluateJavaScript(jsTitle) { gotTitle, titleError in
                var title: String? = nil
                if let cont = gotTitle as? String {
                        title = cont
                }
                webView.evaluateJavaScript( jsBody) { gotBody, bodyError in
                    if let cont = gotBody as? String {
                            self.parent.onFinishNavigation( cont, title)
                    }  else {
                        // print("bad js result")
                        // print(webView.url?.absoluteString ?? "no url")
                        if let cont2 = gotBody {
                            // print("non string result")
                            // print(cont2)
                        }
                    }
                    if let cont3 = bodyError {
                        // print("js error")
                        // print(cont3)
                    }
                } //clo 2
            } //clo1
        } //func nav
    } //coord
    
    @Binding var targetAddr: String
    let onFinishNavigation: OnFinishNavigationCallback
    @State private var cc = ChangeChecker()
    
    func makeUIView(context: Context) -> WKWebView {
        let conf = WKWebViewConfiguration()
        //let ucc = WKUserContentController()
        //conf.userContentController = ucc
        let uss = WKUserScript(source: "document.body.innerText", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        //let uss = WKUserScript(source: "alert('it works')", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        //let uss = WKUserScript(source: "", injectionTime: .atDocumentStart, forMainFrameOnly: true)
        conf.userContentController.addUserScript(uss)
        //conf.userContentController.add( self.makeCoordinator(), name: "IOSNative")
        conf.userContentController.add( context.coordinator, name: "IOSNative")
        //let prefs = WKPreferences()
        //prefs.javaScriptEnabled = true
        let wpprefs = WKWebpagePreferences()
        wpprefs.allowsContentJavaScript = true
        //conf.preferences = prefs
        let wv = WKWebView(frame: CGRect.zero, configuration: conf)
        wv.navigationDelegate = context.coordinator
        wv.allowsBackForwardNavigationGestures = true
        wv.allowsLinkPreview = false
        wv.scrollView.isScrollEnabled = true
        return wv
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if self.cc.addr != self.targetAddr {
            self.cc.addr = self.targetAddr
            if let url = URL(string: self.targetAddr) {
                let req = URLRequest(url: url)
                uiView.load(req)
            } //good addr
        } //dif url
    } //update
func makeCoordinator() -> WKNav {
        WKNav( parent: self)
    }
}

class ChangeChecker {
    var addr: String?
}
