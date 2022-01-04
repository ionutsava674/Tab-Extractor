//
//  TouchTabViewer.swift
//  Tab Extractor
//
//  Created by Ionut on 31.12.2021.
//

import SwiftUI

struct HorizontalTabLister: View {
    @ObservedObject var tab: GuitarTab
    
    @AppStorage( wrappedValue: GLBP.includeBarsDefault, GLBP.includeBars.rawValue) private var includeBars
    @AppStorage( wrappedValue: GLBP.stringStringSepparatorDefault, GLBP.stringStringSeparator.rawValue) var stringStringSeparator
    @AppStorage( wrappedValue: GLBP.stringNoteSeparatorDefault, GLBP.stringNoteSeparator.rawValue) var stringNoteSeparator
    @AppStorage( wrappedValue: GLBP.noteNoteSeparatorDefault, GLBP.noteNoteSeparator.rawValue) var noteNoteSeparator
    
    func getSizes(tabPage: GuitarTab.Page) -> [CGFloat] {
        guard let lastClust = tabPage.clusters.last else {
            return []
        }
        let lastEndI: Int = lastClust.notes.reduce(0, { end, note in
            Swift.max( end, note.position + note.length)
        })
        let lastEnd = CGFloat(lastEndI)
        print("asdf \(lastEnd)")
        let sizes: [CGFloat] = tabPage.clusters.map({
            let maxEnd: Int = $0.notes.reduce(0, { end, note in
                Swift.max( end, note.position + note.length)
            })
            print(maxEnd - $0.minPosition)
            return CGFloat(maxEnd - $0.minPosition) / lastEnd
        })
        return sizes
    } //func
    func putPage(tabPage: GuitarTab.Page) -> some View {
        let toDisplay = tabPage.computeDisplayableClustersEx(for: tabPage.clusters, includeHeader: false, includeBars: includeBars, headerLineStringNameSeparator: stringStringSeparator, stringValueSeparator: stringNoteSeparator, noteNoteSeparator: noteNoteSeparator)
        //let sizes = getSizes2(of: tabPage.clusters)
        let ratio = toDisplay.isEmpty ? 1.0 : 1.0 / CGFloat(toDisplay.count)
        return GeometryReader { geo in
            HStack(alignment: .center, spacing: 0) {
            ForEach(toDisplay, id: \.idForUI) {clust in
                Rectangle()
                    .fill(Color.white)
                    .frame(width: geo.size.width * ratio, alignment: .center)
                    .accessibilityElement()
                    .accessibilityLabel( clust.content)
            } //fe
            } //hs
        } //geo
    } //each page
    var body: some View {
        List {
        ForEach( tab.pages) {page in
            Section(header: Text(page.title)) {
                    putPage(tabPage: page)
                        .frame(maxWidth: .infinity, idealHeight: 120, maxHeight: 120, alignment: .topLeading)
            } //se
        } //fe
        } //ls
    } //body
} //str
