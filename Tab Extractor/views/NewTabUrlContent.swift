//
//  NewTabUrlContent.swift
//  Tab Extractor
//
//  Created by Ionut on 30.05.2021.
//

import SwiftUI

struct NewTabUrlContent: View {
    @Environment(\.presentationMode) private var premo
    let initialAddress: String
    let browseAutomatically: Bool
    @State private var editAddressStr = ""
    @FocusState private var addressFocused: Bool
    @State private var statusStr = NSLocalizedString("status", comment: "browser initial status")
    @State private var browserAddressStr = "about:blank"
    
    @State private var tabFromWeb: GuitarTab?
    @State private var showingPageViewer = false
    
    @State private var fromWebLines: [String] = []
    @State private var showingAddressActions = false
    
    var body: some View {
        NavigationView {
        VStack {
            HStack {
                TextField(NSLocalizedString("web address", comment: "web address placeholder"), text: self.$editAddressStr)
                    .focused($addressFocused)
                    .keyboardType(.URL)
                    .submitLabel(.go)
                Button {
                    self.showingAddressActions = true
                } label: {
                    Image(systemName: "circle")
                        .accessibilityLabel("more actions")
                }
                .confirmationDialog("address actions", isPresented: $showingAddressActions) {
                    Button("Paste and load address") {
                        //
                    }
                } message: {
                    Text("Select an action")
                } //dlg

                
                Button(NSLocalizedString("Go", comment: "start browsing")) {
                    goButtonClick()
                } //btn
                .font(.title)
            } //hs
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
            //Button(NSLocalizedString("add manually", comment: "")) {
                //self.showingLineSelector = true
            //}
            //.hidden()
            SwiftUIWebView( targetAddr: self.$browserAddressStr) { resultStr in
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
        } //vs
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
                } //as
            } //if
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.addressFocused = true
                }
            }
        }) //onapp
    } //body
    func goButtonClick() -> Void {
        //self.showingPageViewer = true
        //DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.browserAddressStr = self.editAddressStr
        //} //dq
    }
} //struct
