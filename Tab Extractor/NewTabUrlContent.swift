//
//  NewTabUrlContent.swift
//  Tab Extractor
//
//  Created by Ionut on 30.05.2021.
//

import SwiftUI

struct NewTabUrlContent: View {
    let initialAddress: String
    let browseAutomatically: Bool
    @State private var editAddressStr = ""
    @State private var statusStr = NSLocalizedString("status", comment: "")
    @State private var browserAddressStr = "about:blank"
    
    @State private var tabFromWeb: GuitarTab?
    @State private var showingPageViewer = false
    
    @State private var fromWebLines: [String] = []
    @State private var showingLineSelector = false
    
    var body: some View {
        NavigationView {
        VStack {
            HStack {
                TextField(NSLocalizedString("web address", comment: "web address to start browsing"), text: self.$editAddressStr)
                Button(NSLocalizedString("Go", comment: "start browsing")) {
                    goButtonClick()
                } //btn
                .font(.title)
            } //hs
            SwiftUIWebView(targetAddr: self.$browserAddressStr) { resultStr in
                let utext = resultStr.replacingOccurrences(of: "\r\n", with: "\n")
                let lns = utext.components(separatedBy: "\n").map { $0.trimmingCharacters(in: .whitespaces) }
                
                let td = TabDetector()
                let gt = td.detectTabs2(text: resultStr, parseAlg: TabParseAlg2())
                gt.sourceUrl = self.browserAddressStr
                
                DispatchQueue.main.async {
                    self.fromWebLines = lns
                    self.tabFromWeb = gt
                    self.statusStr = String.localizedStringWithFormat(NSLocalizedString("detected %1$d tabs", comment: "status"), gt.pages.count)
                    if !gt.pages.isEmpty {
                        self.showingPageViewer = true
                    }
                } //async
            } //web
            //TextEditor(text: $plainText)
            HStack {
                Button(action: {
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
            .font(.title)
            Button(NSLocalizedString("add manually", comment: "")) {
                self.showingLineSelector = true
            }
            .hidden()
        } //vs
        .sheet(isPresented: self.$showingLineSelector, content: {
            LineSelector(linesToShow: fromWebLines[0...])
        })
        .fullScreenCover(isPresented: $showingPageViewer, content: {
            TabPageView( srcTab: tabFromWeb ?? GuitarTab())
        })
        .navigationTitle(NSLocalizedString("Load from website", comment: "load from web window title"))
        .navigationBarTitleDisplayMode(.inline)
        } //nv
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: {
            self.editAddressStr = self.initialAddress
            if browseAutomatically {
                DispatchQueue.main.async {
                    self.goButtonClick()
                }
            }
        })
    } //body
    func goButtonClick() -> Void {
        //self.showingPageViewer = true
        //DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.browserAddressStr = self.editAddressStr
        //} //dq
    }
} //struct
