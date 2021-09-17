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
    
    @AppStorage( wrappedValue: GLBP.includeBarsDefault, GLBP.includeBars.rawValue) private var includeBars
    @AppStorage( wrappedValue: GLBP.stringStringSepparatorDefault, GLBP.stringStringSeparator.rawValue) var stringStringSeparator
    @AppStorage( wrappedValue: GLBP.stringNoteSeparatorDefault, GLBP.stringNoteSeparator.rawValue) var stringNoteSeparator
    @AppStorage( wrappedValue: GLBP.noteNoteSeparatorDefault, GLBP.noteNoteSeparator.rawValue) var noteNoteSeparator
    
    func a()  {
        let page = GuitarTab.Page()
    }
    var originalList: some View {
        ForEach(tab.pages) {page in
            Section(header: Text(page.title)) {
                let linesToList = self.viewSourceLines
                    ? page.sourceStrings
                    : page.computeDisplayableLinesEx(clusts: page.clusters,
                                                     includeBars: self.includeBars,
                                                     headerLineStringNameSeparator: self.stringStringSeparator,
                                                     stringValueSeparator: self.stringNoteSeparator,
                                                     noteNoteSeparator: self.noteNoteSeparator)
                ForEach(linesToList , id: \.self) {line in
                //ForEach(page.displayableLines, id: \.self) { line in
                    Text(line)
                } //fe
            } //se
        } //fe
    }
    var listComputedLines: some View {
        ForEach(tab.pages) {page in
            Section(header: Text(page.title)) {
                let linesToList = page.computeDisplayableLinesEx(clusts: page.clusters,
                                                     includeBars: self.includeBars,
                                                     headerLineStringNameSeparator: self.stringStringSeparator,
                                                     stringValueSeparator: self.stringNoteSeparator,
                                                     noteNoteSeparator: self.noteNoteSeparator)
                ForEach(linesToList , id: \.self) {line in
                    Text(line)
                        .padding(.leading, 80)
                } //fe
            } //se
        } //fe
    } //computedlines
    var listSourceLines: some View {
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
    } //originallines
    var body: some View {
        //NavigationView {
            VStack {
                Text(tab.title)
                    .font(.headline)
                List {
                    if self.viewSourceLines {
                    listSourceLines
                    } else {
                        listComputedLines
                    }
                } //ls
                HStack(alignment: .center, spacing: 20, content: {
                    Button("Share 2") {
                        share2()
                    }
                    Button("Share") {
                        shareTab()
                    }
                }) //hs
                .font(.title)
                .popover(isPresented: $showingShareSheet, attachmentAnchor: .point(UnitPoint.bottom), arrowEdge: .top, content: {
                    ShareSheet( activityItems: self.si.sharedItems)
                })
            } //vs
            //.navigationTitle(tab.title)
        //} //nv
        //.navigationViewStyle(StackNavigationViewStyle())
    } //body
    func share2() -> Void {
        guard !tab.pages.isEmpty else {
            return
        }
        let sts = [ tab.pages.map { page in
            page.displayableLines.joined(separator: "\r\n")
        }
        .joined(separator: "\r\n\r\n")
        ]
        //self.sharedItems = sts
        self.si.sharedItems = sts
        self.showingShareSheet = true
    }
    func shareTab() -> Void {
        guard !tab.pages.isEmpty else {
            return
        }
        let sts = [ tab.pages.map { page in
            page.displayableLines.joined(separator: "\r\n")
        }
        .joined(separator: "\r\n\r\n")
        ]
        guard let source = UIApplication.shared.windows.last?.rootViewController else {
            return
        }
        let av = UIActivityViewController(activityItems: sts, applicationActivities: nil)
        if let popOverController = av.popoverPresentationController {
            popOverController.sourceView = source.view
            popOverController.sourceRect = CGRect(x: source.view.bounds.midX,
                                                  y: source.view.bounds.midY,
                                                  width: .zero, height: .zero)
            popOverController.permittedArrowDirections = []
        }
        source.present(av, animated: true, completion: nil)
        //UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: {
            //print("shared")
        //})        
    } //func
} //struct

class SharedItemsContainer: ObservableObject {
    var sharedItems: [Any] = []
}
