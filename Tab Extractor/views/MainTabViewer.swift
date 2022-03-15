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
    //public var si = SharedItemsContainer()
    @StateObject var sic = SharedItemsContainer()
    
    @State private var showingExport = false
    @State private var exportDoc: TabTextDocument?
    
    @State private var showNavHintDialog = false
    @State private var showingHelp = false
    
    var listSourceLines: some View {
        List {
        ForEach(tab.pages) {page in
            Section(header: Text(String.localizedStringWithFormat(NSLocalizedString("%1$@ (%2$d positions)", comment: ""), page.title, page.clusters.count))) {
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
            VStack {
                /*
                Text(tab.title)
                    .font(.headline.bold())
                    .padding(.horizontal)
                 */
                //Text("contains \(tab.pages.count) \(tab.pages.count == 1 ? "tab" : "tabs")")
                Text(String.localizedStringWithFormat(NSLocalizedString("contains %1$d %2$@", comment: "contains label"), tab.pages.count, LCLZ.singleMany(tab.pages.count, LCLZ.singleTab, LCLZ.manyTabs)))
                    .font(.headline)
                    .onLongPressGesture {
                        glop.showNavHint1 = true
                    }
                    if glop.viewSourceLines {
                    listSourceLines
                    } else {
                        if glop.viewHorizontally {
                            HorizontalTabLister( tab: tab)
                        } else {
                            VerticalTabLister( tab: tab)
                        } //if vert
                    } //if comp
                HStack(alignment: .center, spacing: 4, content: {
                    NavigationLink {
                        TabViewerHelpView()
                    } label: {
                        Image(systemName: "questionmark.diamond")
                            .accessibilityLabel("Navigation help")
                            .padding()
                    } //nl
                    /*
                    Button(action: {
                        self.showingHelp = true
                    }, label: {
                        Image(systemName: "questionmark.diamond")
                    })
                        .accessibilityLabel("Navigation help")
                    .padding()
                     */
                    Spacer()
                    Button("Export") {
                        DispatchQueue.main.async {
                            //let ts = self.tabToString(tab, originalMode: glop.viewSourceLines)
                            //print("\(ts.count)")
                            self.exportDoc = TabTextDocument(initialText: self.tabToString(tab, originalMode: glop.viewSourceLines))
                            //print("\(tab.title).txt")
                            self.showingExport = true
                        }
                    }
                    .padding()
                    Button("Share") {
                        share2()
                    } //btn
                    .padding()
                }) //hs
                .font(.title)
            } //vs
            .sheet(isPresented: self.$showingHelp, onDismiss: {
                //
            }, content: {
                TabViewerHelpView(asSheet: true)
            })
            .popover(isPresented: $showingShareSheet, attachmentAnchor: .point(UnitPoint.bottom), arrowEdge: .top, content: {
                ShareSheet( activityItems: self.sic.sharedItems)
            }) //pop
            .fileExporter(isPresented: self.$showingExport, document: self.exportDoc, contentType: .plainText, defaultFilename: "\(tab.title.changeToFileNameLegal()).txt", onCompletion: { result in
                //
            }) //export
            .onAppear(perform: {
                if glop.showNavHint1 {
                    self.showNavHintDialog = true
                }
            }) //onapp
            .alert("Navigation hint", isPresented: self.$showNavHintDialog, actions: {
                Button(role: .cancel) {
                    //
                } label: {
                    Label("dismiss", systemImage: "xmark.circle")
                }

                Button {
                    self.showingHelp = true
                } label: {
                    Label("more info", systemImage: "questionmark.circle")
                }

                Button(role: .destructive) {
                    glop.showNavHint1 = false
                } label: {
                    Label("don't show this again", systemImage: "hand.thumbsup.circle")
                }
            }, message: {
                Text("You can mark a position with a long press (voiceover triple tap), and focus from any position to the marked position with a single activation (voiceover double-tap).")
            }) //alert
            .navigationTitle(tab.title)
            // .navigationBarTitleDisplayMode(.inline)
    } //body
    
    func tabToString(_ gt: GuitarTab,originalMode: Bool = false) -> String {
        var result: [String] = [
            //"exported song:",
            gt.title, "\(gt.pages.count) tabs"]
        let formatter = DisplayableClusterFormatter(stringToValueSeparator: glop.stringNoteSeparator, noteNoteSeparator: glop.noteNoteSeparator, stringHeaderSeparator: glop.stringStringSeparator)
        for page in gt.pages {
            result.append("")
            result.append( page.title)
            if originalMode {
                result.append(contentsOf: page.sourceStrings)
            } else {
                let stringNames = page.getStringNames( from: page.clusters, or: nil)
                let positionsToDisplay = page.filterClusters(from: page.clusters, includeHeader: glop.includeHeader, includeBars: glop.includeBars)
                result.append(contentsOf: positionsToDisplay.map({ clust in
                    formatter.makeDisplayText(from: clust, asHeader: clust === page.headerCluster, withStringNames: stringNames)
                }))
            }
        } //for
        return result.joined(separator: glop.endOfLine)
    } //eof
    func share2() -> Void {
        guard !tab.pages.isEmpty else {
            return
        }
        //let exDoc = TabTextDocument(initialText: self.tabToString(tab, originalMode: glop.viewSourceLines))
        let sts = [tabToString( tab, originalMode: glop.viewSourceLines)]
        //let sts = [exDoc]
        self.sic.sharedItems = sts
        self.showingShareSheet = true
    } //func
} //struct

class SharedItemsContainer: ObservableObject {
    var sharedItems: [Any] = []
}
