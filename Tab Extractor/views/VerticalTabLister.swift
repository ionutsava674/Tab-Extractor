//
//  VerticalTabLister.swift
//  Tab Extractor
//
//  Created by Ionut on 03.01.2022.
//

import SwiftUI

struct VerticalTabLister: View {
    @ObservedObject var tab: GuitarTab
    
    @AppStorage( wrappedValue: GLBP.includeBarsDefault, GLBP.includeBars.rawValue) private var includeBars
    @AppStorage( wrappedValue: GLBP.stringStringSepparatorDefault, GLBP.stringStringSeparator.rawValue) var stringStringSeparator
    @AppStorage( wrappedValue: GLBP.stringNoteSeparatorDefault, GLBP.stringNoteSeparator.rawValue) var stringNoteSeparator
    @AppStorage( wrappedValue: GLBP.noteNoteSeparatorDefault, GLBP.noteNoteSeparator.rawValue) var noteNoteSeparator
    
    @AccessibilityFocusState private var aiFocused: UUID?
    @State private var markedCluster: UUID?
    
    func putVerticalPage( page: GuitarTab.Page, scrollProxy: ScrollViewProxy) -> some View {
        let stringNames = page.getStringNames( from: page.clusters, or: nil)
        let elementsToDisplay = page.computeDisplayableClusters2(for: page.clusters, includeHeader: false, includeBars: includeBars)
        let formatter = DisplayableClusterFormatter(stringToValueSeparator: stringNoteSeparator, noteNoteSeparator: noteNoteSeparator, stringHeaderSeparator: stringStringSeparator)
        
        return ForEach(elementsToDisplay , id: \.idForUI) {clust in
            Text( formatter.makeDisplayText(from: clust, withStringNames: stringNames) )
                //.accessibilityLabel( self.markedCluster == line.idForUI ? "\(line.content), marked" : line.content)
                .id( clust.idForUI )
                .accessibilityFocused($aiFocused, equals: clust.idForUI)
                .padding(.leading, 80)
                .onTapGesture {
                    if let mc = self.markedCluster {
                        //scrollProxy.scrollTo(mc)
                        self.aiFocused = mc
                        //UIAccessibility.post(notification: UIAccessibility.Notification.announcement, argument: "going to marked spot")
                    }
                }
                .onLongPressGesture {
                    UIAccessibility.post(notification: UIAccessibility.Notification.announcement, argument: "marking spot")
                    self.markedCluster = clust.idForUI
                }
        } //fe
    }
        var body: some View {
            ScrollViewReader { sv in
        List {
        ForEach(tab.pages) {page in
            Section(header: Text(page.title)) {
                    putVerticalPage( page: page, scrollProxy: sv)
            } //se
        } //fe
        } //ls
            } //sv
    } //body
} //str
