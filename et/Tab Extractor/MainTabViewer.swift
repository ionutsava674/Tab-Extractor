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
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(tab.pages) {page in
                        Section(header: Text("tab page")) {
                            ForEach(page.displayableLines, id: \.self) { line in
                                Text(line)
                            } //fe
                        } //se
                    } //fe
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
            .navigationTitle(tab.title)
        } //nv
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
