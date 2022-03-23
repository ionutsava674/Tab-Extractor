//
//  VerticalTabLister.swift
//  Tab Extractor
//
//  Created by Ionut on 03.01.2022.
//

import SwiftUI

struct VerticalTabLister: View {
    @ObservedObject var tab: GuitarTab
    @ObservedObject private var glop = GlobalPreferences2.global

    @AccessibilityFocusState private var aiFocused: UUID?
    @State private var markedCluster: UUID?
    
    func putVerticalPage( page: GuitarTab.Page, scrollProxy: ScrollViewProxy) -> some View {
        let stringNames = page.getStringNames( from: page.clusters, or: nil)
        let elementsToDisplay = Array( page.filterClusters(from: page.clusters, includeHeader: glop.includeHeader, includeBars: glop.includeBars).enumerated() )
        let formatter = DisplayableClusterFormatter(stringToValueSeparator: glop.stringNoteSeparator, noteNoteSeparator: glop.noteNoteSeparator, stringHeaderSeparator: glop.stringStringSeparator)
        
        return ForEach(elementsToDisplay, id: \.element.idForUI) {(clustIndex, clust) in
            Text( "\(formatter.makeDisplayText(from: clust, asHeader: clust === page.headerCluster, withStringNames: stringNames))\(self.markedCluster == clust.idForUI ? ", marked" : "")" )
                .id( clust.idForUI )
                .accessibilityFocused($aiFocused, equals: clust.idForUI)
                .padding(.leading, 80)
                .onTapGesture {
                    if let mc = self.markedCluster {
                        scrollProxy.scrollTo(mc)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            self.aiFocused = mc
                        }
                        //UIAccessibility.post(notification: UIAccessibility.Notification.announcement, argument: "going to marked spot")
                    }
                } //tap
                .onLongPressGesture {
                    UIAccessibility.post(notification: UIAccessibility.Notification.announcement, argument: "marking position \(clustIndex + 1)")
                    self.markedCluster = clust.idForUI
                } //lontap
        } //fe
    }
        var body: some View {
            ScrollViewReader { sv in
        List {
        ForEach(tab.pages) {page in
            //Section(header: Text(page.title)) {
            Section(header: Text(String.localizedStringWithFormat(NSLocalizedString("%1$@ (%2$d positions)", comment: ""), page.title, page.clusters.count))) {
                    putVerticalPage( page: page, scrollProxy: sv)
            } //se
        } //fe
        } //ls
            } //sv
    } //body
} //str
