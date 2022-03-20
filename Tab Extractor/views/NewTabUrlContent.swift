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
    var initialAddress: String?
    var autoFetchClipBoard: Bool
    let browseAutomatically: Bool
    let shouldCloseAfterSaving: ShouldAutoCloseBehaviour

    @ObservedObject private var glop = GlobalPreferences2.global
    @Environment(\.presentationMode) private var premo
    
    @State private var didSaveAnyTabs = false
    @State private var editAddressStr = ""
    @FocusState private var addressFocused: Bool
    @State private var statusStr = NSLocalizedString("status", comment: "browser initial status")
    @State private var showZeroResultsFound = false
    @State private var browserAddressStr = "about:blank"
    private var browserAddrEmpty: Bool {
        browserAddressStr.isEmpty ||
        browserAddressStr == "about:blank"
    }
    
    @State private var tabFromWeb: GuitarTab?
    @State private var pageBodyFromWeb: String?
    @State private var pageTitleFromWeb: String?
    
    @State private var showingPageViewer = false
    @State private var showingAddressActions = false
    
    var body: some View {
        NavigationView {
        VStack {
            HStack {
                TextField(NSLocalizedString("enter a web address that contains guitar tablatures", comment: "web address placeholder 2"), text: self.$editAddressStr)
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
                        if self.pasteClipboard() {
                            self.goButtonClick()
                        }
                    } //btn
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
                            Image(systemName: "xmark").renderingMode(.original)
                            //.font(.largeTitle)
                    } //btn
                }) //t b i
            }) //tb
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
        .fullScreenCover(isPresented: $showingPageViewer, onDismiss: {
            let shouldClose: Bool = (self.shouldCloseAfterSaving == .always)
            || (self.shouldCloseAfterSaving == .onlyIfDidSave && self.didSaveAnyTabs)
            if shouldClose {
                DispatchQueue.main.async {
                    premo.wrappedValue.dismiss()
                } //dq
            } //if
        }, content: {
            TabPageView( srcTab: tabFromWeb ?? GuitarTab(), didSaveTabs: $didSaveAnyTabs)
        })
        //.fullScreenCover(isPresented: $showingPageViewer, content: {
            //TabPageView( srcTab: tabFromWeb ?? GuitarTab())
        //})
        .navigationTitle(NSLocalizedString("Load from website", comment: "load from web window title"))
        .navigationBarTitleDisplayMode(.inline)
        } //nv
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: {
            DispatchQueue.main.async {
                if placeAddress() {
                    if browseAutomatically {
                        goButtonClick()
                    }
                }
            } //dq
        }) //onapp
    } //body
    
    func browserDidFinishNavigation(resultStr: String, titleStr: String?) -> Void {
        //let utext = resultStr.replacingOccurrences(of: "\r\n", with: "\n")
        //let lns = utext.components(separatedBy: "\n").map { $0.trimmingCharacters(in: .whitespaces) }
        //print(self.browserAddressStr)
        //print(resultStr)
        let captAddr  = self.browserAddressStr
        //print("gua1 \(resultStr.isEmpty) \(Date.now)")
        DispatchQueue.main.async {
            //print("gua2 \(resultStr.isEmpty) \(Date.now)")
            if !resultStr.isEmpty {
                self.statusStr = NSLocalizedString("processing content", comment: "status when done loading ")
            }
            self.pageBodyFromWeb = resultStr
            self.pageTitleFromWeb = titleStr?.limitToTitle(of: 128)
        } //as
        //guard !resultStr.isEmpty else {
            //return
        //}
        DispatchQueue.global( qos: .userInitiated).async {
            let td = TabDetector()
            if let gt = td.detectTabs3(in: resultStr, using: TabParseAlg2(), splitMultipleOf: [6, 4]) {
                gt.sourceUrl = captAddr
                gt.title = titleStr?.limitToTitle( of: 64) ?? ""
                DispatchQueue.main.async {
                    self.tabFromWeb = gt
                    self.statusStr = String.localizedStringWithFormat(NSLocalizedString("show %1$d detected tabs", comment: "status"), gt.pages.count)
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
    func pasteClipboard() -> Bool {
        if UIPasteboard.general.hasURLs {
            if let firstUrl = UIPasteboard.general.urls?.first {
                self.editAddressStr = firstUrl.absoluteString
                return true
            }
        }
        if UIPasteboard.general.hasStrings {
            if let firstStr = UIPasteboard.general.strings?.first(where: {
                if let _ = URL(string: $0) {
                    return true
                }
                return false
            }) {
                self.editAddressStr = firstStr
                return true
            }
        }
        return false
    } //func
    func placeAddress() -> Bool {
        if autoFetchClipBoard {
            if pasteClipboard( ) {
                return true
            }
        } //if fetch
        if let ia = initialAddress {
            self.editAddressStr = ia
            return true
        } //if got str
        return false
    } //func
    func goButtonClick() -> Void {
        guard self.browserAddressStr != self.editAddressStr else {
            return
        }
            self.browserAddressStr = self.editAddressStr
        if !browserAddrEmpty {
            self.statusStr = NSLocalizedString("loading", comment: "status when started loading ")
        }
    } //func
} //struct

enum ShouldAutoCloseBehaviour {
case no, always, onlyIfDidSave
}
