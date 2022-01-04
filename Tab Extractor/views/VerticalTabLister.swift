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
        let toDisplay = page.computeDisplayableClustersEx(for: page.clusters, includeHeader: false, includeBars: includeBars, headerLineStringNameSeparator: stringStringSeparator, stringValueSeparator: stringNoteSeparator, noteNoteSeparator: noteNoteSeparator)
        return ForEach(toDisplay , id: \.idForUI) {line in
            Text( self.markedCluster == line.idForUI ? "\(line.content), marked" : line.content)
                .accessibilityLabel( self.markedCluster == line.idForUI ? "\(line.content), marked" : line.content)
                .id(line.idForUI)
                .accessibilityFocused($aiFocused, equals: line.idForUI)
                .padding(.leading, 80)
                .onTapGesture {
                    if let mc = self.markedCluster {
                        //scrollProxy.scrollTo(mc)
                        self.aiFocused = mc
                        UIAccessibility.post(notification: UIAccessibility.Notification.announcement, argument: "going to marked spot")
                    }
                }
                .onLongPressGesture {
                    UIAccessibility.post(notification: UIAccessibility.Notification.announcement, argument: "marking spot")
                    self.markedCluster = line.idForUI
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
