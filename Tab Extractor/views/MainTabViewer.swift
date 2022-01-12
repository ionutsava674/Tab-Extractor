//
//  MainTabViewer.swift
//  Tab Extractor
//
//  Created by Ionut on 13.06.2021.
//

import SwiftUI

struct MainTabViewer: View {
    @ObservedObject var tab: GuitarTab
    @ObservedObject private var glop = GlobalPreferences2.global

    @State private var showingShareSheet = false
    public var si = SharedItemsContainer()
    
    @State private var showNavHintDialog = false
    
    var listSourceLines: some View {
        List {
        ForEach(tab.pages) {page in
            Section(header: Text("\(page.title) (\(page.clusters.count) positions)")) {
            //Section(header: Text(page.title)) {
                let linesToList = page.sourceStrings
                ForEach(linesToList , id: \.self) {line in
                    Text(line)
                        //.padding(.leading, 80)
                        .font(.system(.body, design: .monospaced))
                } //fe
            } //se
        } //fe
        } //ls
    } //originallines
    var body: some View {
        //NavigationView {
            VStack {
                Text(tab.title)
                    .font(.title)
                    .onLongPressGesture {
                        glop.showNavHint1 = true
                    }
                Text("contains \(tab.pages.count) \(tab.pages.count == 1 ? "tab" : "tabs")")
                    .font(.headline)
                    if glop.viewSourceLines {
                    listSourceLines
                    } else {
                        if glop.viewHorizontally {
                            HorizontalTabLister( tab: tab)
                        } else {
                            VerticalTabLister( tab: tab)
                        } //if vert
                    } //if comp
                HStack(alignment: .center, spacing: 20, content: {
                    Spacer()
                    Button("Share") {
                        share2()
                    } //btn
                }) //hs
                .font(.title)
                .popover(isPresented: $showingShareSheet, attachmentAnchor: .point(UnitPoint.bottom), arrowEdge: .top, content: {
                    ShareSheet( activityItems: self.si.sharedItems)
                }) //pop
            } //vs
            .onAppear(perform: {
                if glop.showNavHint1 {
                    self.showNavHintDialog = true
                }
            })
            .alert("Navigation hint", isPresented: self.$showNavHintDialog, actions: {
                Button(role: .cancel) {
                    //
                } label: {
                    Label("dismiss", systemImage: "xmark.circle")
                }

                Button {
                    //
                } label: {
                    Label("more info", systemImage: "questionmark.circle")
                }

                Button(role: .destructive) {
                    glop.showNavHint1 = false
                } label: {
                    Label("don't show this again", systemImage: "hand.thumbsup.circle")
                }
            }, message: {
                Text("You can mark a position with a long press (voiceover triple tap),\r\nand focus from any position to the marked position with a single activation (voiceover double-tap).")
            })
            // .navigationTitle(tab.title)
        //} //nv
        //.navigationViewStyle(StackNavigationViewStyle())
    } //body
    
    func share2() -> Void {
        guard !tab.pages.isEmpty else {
            return
        }
        let formatter = DisplayableClusterFormatter(stringToValueSeparator: glop.stringNoteSeparator, noteNoteSeparator: glop.noteNoteSeparator, stringHeaderSeparator: glop.stringStringSeparator)
        let cont = tab.pages.map({ page in
            let stringNames = page.getStringNames( from: page.clusters, or: nil)
            let elementsToDisplay = page.filterClusters(from: page.clusters, includeHeader: glop.includeHeader, includeBars: glop.includeBars)
            return "\(page.title)\r\n" +
            elementsToDisplay.map({ clust in
                formatter.makeDisplayText(from: clust, asHeader: clust === page.headerCluster, withStringNames: stringNames)
            }).joined(separator: "\r\n")
        }).joined(separator: "\r\n\r\n")
        let sts = ["\(tab.title)\r\n\(tab.pages.count) tabs\r\n\r\n\(cont)"]
        //print(sts[0])
        //self.sharedItems = sts
        self.si.sharedItems = sts
        self.showingShareSheet = true
    } //func
} //struct

class SharedItemsContainer: ObservableObject {
    var sharedItems: [Any] = []
}
