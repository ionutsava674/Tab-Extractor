//
//  NewTabFromTextContent.swift
//  Tab Extractor
//
//  Created by Ionut on 26.12.2021.
//

import SwiftUI
import UIKit

struct NewTabFromTextContent: View {
    @ObservedObject private var glop = GlobalPreferences2.global
    @Environment(\.presentationMode) private var premo
    @State private var memoStr = ""
    @FocusState private var memoFocused: Bool
    
    @State private var statusStr = NSLocalizedString("no tabs found", comment: "status on text")
    
    @State private var tabFromText: GuitarTab?
    @State private var showingPageViewer = false
    
    @State private var showZeroResultsFound = false

    init() {
        UITextView.appearance().textDragInteraction?.isEnabled = false
        UITextView.appearance().isScrollEnabled = true
        //UITextView.wra
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 4) {
                //Button("reset") { glop.showZeroResultsFound2 = true }
            HStack {
                Spacer()
                Button(action: {
                    self.showPageViewer()
                }, label: {
                    Text( self.statusStr)
                })//btn
                    .disabled( tabFromText?.pages.isEmpty ?? true)
                Spacer()
            } //hs
            .contentShape(Rectangle())
            HStack {
                Spacer()
                Button(action: {
                    self.DetectTab()
                }, label: {
                    Text( NSLocalizedString("detect", comment: "detect button"))
                })//btn
                    .disabled( memoStr.isEmpty)
                Spacer()
            } //hs
            .contentShape(Rectangle())
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Button {
                        self.premo.wrappedValue.dismiss()
                    } label: {
                            Image(systemName: "xmark").renderingMode(.original)
                    } //btn
                }) //t b i
            }) //tb
            //ScrollView([.horizontal, .vertical] , showsIndicators: true) {
                TextEditor(text: $memoStr)
                .focused($memoFocused)
                    .multilineTextAlignment(.leading)
                    .allowsTightening( false)
                    .textSelection(.enabled)
                    .toolbar {
                        ToolbarItem(placement: .keyboard) {
                            HStack(alignment: .center, spacing: 8) {
                                Spacer()
                                Button(NSLocalizedString("clear text", comment: "tool button")) {
                                    self.memoStr = ""
                                } //btn
                                Button(NSLocalizedString("dismiss keyboard", comment: "tool button")) {
                                    self.memoFocused = false
                                } //btn
                            } //hs
                        } //tbi
                    } //tb
            //} //sv
            //.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        } //vs
        .onAppear(perform: {
            pasteClipboard( andLoad: true)
        }) //onapp
        .alert("no tabs found", isPresented: self.$showZeroResultsFound, actions: {
            Button("don't show this again", role: .destructive) {
                glop.showZeroResultsFound2 = false
            }
            Button("OK", role: .cancel) { }
        }, message: {
            Text("There were no tabs found in the text.")
        }) //alert
        .fullScreenCover(isPresented: $showingPageViewer, content: {
            TabPageView( srcTab: tabFromText ?? GuitarTab())
        }) //sheet
        .navigationTitle(NSLocalizedString("Load from text", comment: "load from text window title"))
        .navigationBarTitleDisplayMode(.inline)
        } //nv
        .navigationViewStyle(StackNavigationViewStyle())
    } //body
    
    func showPageViewer() -> Void {
        self.memoFocused = false
        self.showingPageViewer = true
    }
    func DetectTab( ) -> Void {
        let text = memoStr
        DispatchQueue.global( qos: .userInitiated).async {
            let td = TabDetector()
            if let gt = td.detectTabs3(in: text, using: TabParseAlg2(), splitMultipleOf: [6, 4]) {
                gt.sourceUrl = "pasted manually"
                //gt.title = titleStr?.limitToTitle( of: 64) ?? ""
                DispatchQueue.main.async {
                    self.tabFromText = gt
                    self.statusStr = String.localizedStringWithFormat(NSLocalizedString("show %1$d detected tabs", comment: "show button on load from text"), gt.pages.count)
                    if !gt.pages.isEmpty {
                        showPageViewer()
                    } else {
                        if glop.showZeroResultsFound2 {
                            self.showZeroResultsFound = true
                        }
                    }
                } //masync
            } //got tab
        } //gas
    }
    func pasteClipboard( andLoad: Bool) -> Void {
        if UIPasteboard.general.hasStrings {
            if let fStr = UIPasteboard.general.strings?.first {
                self.memoStr = fStr
                if andLoad {
                    DetectTab()
                }
            }
        }
    } //func
} //str
