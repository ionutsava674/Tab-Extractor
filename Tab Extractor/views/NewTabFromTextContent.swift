//
//  NewTabFromTextContent.swift
//  Tab Extractor
//
//  Created by Ionut on 26.12.2021.
//

import SwiftUI
import UIKit

struct NewTabFromTextContent: View {
    @Environment(\.presentationMode) private var premo
    @State private var memoStr = ""
    @FocusState private var memoFocused: Bool
    @State private var statusStr = NSLocalizedString("status", comment: "text initial status")
    
    @State private var tabFromText: GuitarTab?
    @State private var showingPageViewer = false
    init() {
        UITextView.appearance().textDragInteraction?.isEnabled = false
        UITextView.appearance().isScrollEnabled = true
        //UITextView.wra
    }
    
    var body: some View {
        NavigationView {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.showingPageViewer = true
                }, label: {
                    Text( self.statusStr)
                })
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
                            HStack {
                                Spacer()
                            Button("dismiss keyboard") {
                                self.memoFocused = false
                            } //btn
                            } //hs
                        } //tbi
                    } //tb
            //} //sv
            //.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        } //vs
        .fullScreenCover(isPresented: $showingPageViewer, content: {
            TabPageView( srcTab: tabFromText ?? GuitarTab())
        }) //sheet
        .navigationTitle(NSLocalizedString("Load from text", comment: "load from text window title"))
        .navigationBarTitleDisplayMode(.inline)
        } //nv
        .navigationViewStyle(StackNavigationViewStyle())
    } //body
} //str
