//
//  MainTabViewer.swift
//  Tab Extractor
//
//  Created by Ionut on 13.06.2021.
//

import SwiftUI

struct MainTabViewer: View {
    @ObservedObject var tab: GuitarTab
    
    @State private var showingShareSheet = false
    public var si = SharedItemsContainer()
    
    @AppStorage( wrappedValue: GLBP.viewSourceLinesDefault, GLBP.viewSourceLines.rawValue) var viewSourceLines
    
    //@AppStorage( wrappedValue: GLBP.includeBarsDefault, GLBP.includeBars.rawValue) private var includeBars
    //@AppStorage( wrappedValue: GLBP.stringStringSepparatorDefault, GLBP.stringStringSeparator.rawValue) var stringStringSeparator
    //@AppStorage( wrappedValue: GLBP.stringNoteSeparatorDefault, GLBP.stringNoteSeparator.rawValue) var stringNoteSeparator
    //@AppStorage( wrappedValue: GLBP.noteNoteSeparatorDefault, GLBP.noteNoteSeparator.rawValue) var noteNoteSeparator
    
    @AppStorage( wrappedValue: GLBP.viewHorizontallyDefault, GLBP.viewHorizontally.rawValue) private var viewHorizontally

    var listSourceLines: some View {
        List {
        ForEach(tab.pages) {page in
            Section(header: Text(page.title)) {
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
                    .font(.headline)
                    if self.viewSourceLines {
                    listSourceLines
                    } else {
                        if viewHorizontally {
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
                })
            } //vs
            // .navigationTitle(tab.title)
        //} //nv
        //.navigationViewStyle(StackNavigationViewStyle())
    } //body
    func share2() -> Void {
        guard !tab.pages.isEmpty else {
            return
        }
        let sts = [ tab.pages.map { page in
            page.displayableLines.joined(separator: "\r\n")
            + "\r\nlc \(page.lines.count)"
            + "\r\ncc \(page.clusters.count)"
            + "\r\noc \(page.sourceStrings.count)"
            + page.sourceStrings.joined(separator: "\r\n")
        }
        .joined(separator: "\r\n\r\n")
        ]
        print(sts[0])
        //self.sharedItems = sts
        self.si.sharedItems = sts
        self.showingShareSheet = true
    } //func
} //struct

class SharedItemsContainer: ObservableObject {
    var sharedItems: [Any] = []
}
