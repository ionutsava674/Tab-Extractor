//
//  NewTabUrlContent.swift
//  Tab Extractor
//
//  Created by Ionut on 30.05.2021.
//

import SwiftUI
import UIKit
import Combine

struct NewTabUrlContent: View {
    let initialAddress: String?
    let autoFetchClipBoard: Bool
    let browseAutomatically: Bool
    
    @ObservedObject private var glop = GlobalPreferences2.global
    @Environment(\.presentationMode) private var premo
    
    @State private var editAddressStr = ""
    @FocusState private var addressFocused: Bool
    @State private var statusStr = NSLocalizedString("status", comment: "browser initial status")
    @State private var showZeroResultsFound = false
    @State private var browserAddressStr = "about:blank"
    
    @State private var tabFromWeb: GuitarTab?
    @State private var pageBodyFromWeb: String?
    @State private var pageTitleFromWeb: String?
    
    @State private var showingPageViewer = false
    @State private var showingAddressActions = false
    
    var body: some View {
        NavigationView {
        VStack {
            HStack {
                TextField(NSLocalizedString("web address", comment: "web address placeholder"), text: self.$editAddressStr)
                /*
                    .onReceive(NotificationCenter.default.publisher( for: UITextField.textDidBeginEditingNotification, object: nil), perform: { publisherOutput in
                        if let textField = publisherOutput.object as? UITextField {
                            DispatchQueue.main.async {
                                //textField.selectAll(textField)
                                textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
                                textField.updateFocusIfNeeded()
                            }
                        }
                    })
                 */
                    .focused($addressFocused)
                    .keyboardType(.URL)
                    .submitLabel(.go)
                    .onSubmit {
                        goButtonClick()
                    }
                
                Button {
                    self.showingAddressActions = true
                } label: {
                    Image(systemName: "circle")
                        .accessibilityLabel(NSLocalizedString("more actions", comment: "button on web view"))
                }
                .confirmationDialog("address actions", isPresented: $showingAddressActions) {
                    Button(NSLocalizedString("Paste and load address", comment: "more actions button")) {
                        _ = self.pasteClipboard(andGo: true)
                    }
                    .disabled( !self.clipboardHasUrl() )
                    Button(NSLocalizedString("clear address", comment: "more actions button")) {
                        self.editAddressStr = ""
                    }
                } message: {
                    Text("Select an action")
                } //dlg

                
                Button(NSLocalizedString("Go", comment: "start browsing")) {
                    goButtonClick()
                } //btn
                .font(.title)
                .disabled( self.editAddressStr.isEmpty || self.browserAddressStr == self.editAddressStr)
            } //hs
            HStack {
                Button(action: {
                    self.addressFocused = false
                    self.showingPageViewer = true
                }, label: {
                    Text( self.statusStr)
                        .frame(maxWidth: .infinity)
                        .background(
                            Rectangle()
                                .fill(Color(UIColor.systemBackground))
                        )
                })
            } //hs
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Button {
                        self.premo.wrappedValue.dismiss()
                    } label: {
                        //Text(
                            Image(systemName: "xmark").renderingMode(.original)
                        //)
                            //.font(.largeTitle)
                    } //btn
                }) //t b i
            }) //tb
            //.font(.title)
            SwiftUIWebView( targetAddr: self.$browserAddressStr) { bodyStr, titleStr in
                browserDidFinishNavigation(resultStr: bodyStr, titleStr: titleStr)
            } //web
        } //vs
        .alert("no tabs found", isPresented: self.$showZeroResultsFound, actions: {
            Button(NSLocalizedString("don't show this again", comment: "alert button"), role: .destructive) {
                glop.showZeroResultsFound = false
            }
            Button("OK", role: .cancel) { }
        }, message: {
            Text("The page has finished loading. There were no tabs found on the page.")
        }) //alert
        .fullScreenCover(isPresented: $showingPageViewer, content: {
            TabPageView( srcTab: tabFromWeb ?? GuitarTab())
        })
        .navigationTitle(NSLocalizedString("Load from website", comment: "load from web window title"))
        .navigationBarTitleDisplayMode(.inline)
        } //nv
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: {
            fetchAddress()
        }) //onapp
    } //body
    
    func browserDidFinishNavigation(resultStr: String, titleStr: String?) -> Void {
        //let utext = resultStr.replacingOccurrences(of: "\r\n", with: "\n")
        //let lns = utext.components(separatedBy: "\n").map { $0.trimmingCharacters(in: .whitespaces) }
        //print(self.browserAddressStr)
        //print(resultStr)
        let captAddr  = self.browserAddressStr
        DispatchQueue.main.async {
            self.statusStr = NSLocalizedString("navigation ready", comment: "status when ready to navigate")
            self.pageBodyFromWeb = resultStr
            self.pageTitleFromWeb = titleStr?.limitToTitle(of: 128)
        } //as
        DispatchQueue.global( qos: .userInitiated).async {
            let td = TabDetector()
            if let gt = td.detectTabs3(in: resultStr, using: TabParseAlg2(), splitMultipleOf: [6, 4]) {
                gt.sourceUrl = captAddr
                gt.title = titleStr?.limitToTitle( of: 64) ?? ""
                DispatchQueue.main.async {
                    self.tabFromWeb = gt
                    self.statusStr = String.localizedStringWithFormat(NSLocalizedString("detected %1$d tabs", comment: "status"), gt.pages.count)
                    if !gt.pages.isEmpty {
                        self.addressFocused = false
                        self.showingPageViewer = true
                    } else {
                        if glop.showZeroResultsFound {
                            self.showZeroResultsFound = true
                        }
                    }
                } //masync
            } //got tab
        } //gas
    } //func
    func clipboardHasUrl() -> Bool {
        if UIPasteboard.general.hasURLs {
            return true
        }
        if UIPasteboard.general.hasStrings {
            if let _ = UIPasteboard.general.strings?.first(where: {
                if let _ = URL(string: $0) {
                    return true
                }
                return false
            }) {
                return true
            }
        }
        return false
    } //func
    func pasteClipboard( andGo: Bool) -> Bool {
        if UIPasteboard.general.hasURLs {
            if let furl = UIPasteboard.general.urls?.first {
                self.editAddressStr = furl.absoluteString
                if andGo {
                    goButtonClick()
                }
                return true
            }
        }
        if UIPasteboard.general.hasStrings {
            if let fstr = UIPasteboard.general.strings?.first(where: {
                if let _ = URL(string: $0) {
                    return true
                }
                return false
            }) {
                self.editAddressStr = fstr
                if andGo {
                    goButtonClick()
                }
                return true
            }
        }
        return false
    } //func
    func fetchAddress() -> Void {
        if autoFetchClipBoard {
            if pasteClipboard( andGo: browseAutomatically) {
                return
            }
        } //if fetch
        if let ia = initialAddress {
            self.editAddressStr = ia
            if browseAutomatically {
                goButtonClick()
            }
        } //if got str
                //self.addressFocused = true
    } //func
    func goButtonClick() -> Void {
        //DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.browserAddressStr = self.editAddressStr
        //} //dq
    }
} //struct
