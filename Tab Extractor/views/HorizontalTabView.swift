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
    func putPage2( tabPage: GuitarTab.Page) -> some View {
        AnyContainerView( objectToPass: tabPage.getStringNames(from: tabPage.clusters, or: nil)) { stringNames in
        AnyContainerView(objectToPass: tabPage.computeDisplayableClusters2(for: tabPage.clusters)) { toDisplayClusters in
            AnyContainerView(objectToPass: DisplayableClusterFormatter(stringToValueSeparator: stringNoteSeparator, noteNoteSeparator: noteNoteSeparator, stringHeaderSeparator: stringStringSeparator)) { formatter in
                GeometryReader { geo in
                    HStack(alignment: .center, spacing: 0) {
                        ForEach(toDisplayClusters, id: \.id) {clust in
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: geo.size.width / 100.0,
                                   alignment: .center)
                            .accessibilityElement()
                            .accessibilityLabel( formatter.makeDisplayText(from: clust, asHeader: false, withStringNames: stringNames) )
                    } //fe
                    } //hs
                } //geo
            }
        }
                                             }
    } //each page
    func putPage3( tabPage: GuitarTab.Page) -> some View {
        let stringNames = tabPage.getStringNames( from: tabPage.clusters, or: nil)
        let elementsToDisplay = tabPage.computeDisplayableClusters2(for: tabPage.clusters, includeHeader: false, includeBars: includeBars)
        let formatter = DisplayableClusterFormatter(stringToValueSeparator: stringNoteSeparator, noteNoteSeparator: noteNoteSeparator, stringHeaderSeparator: stringStringSeparator)
        let ratio: CGFloat = elementsToDisplay.isEmpty ? 1.0 : 1.0 / CGFloat(elementsToDisplay.count)
                return GeometryReader { geo in
                    HStack(alignment: .center, spacing: 0) {
                        ForEach(elementsToDisplay, id: \.id) {clust in
                        Rectangle()
                                .strokeBorder(Color.init(UIColor.systemBackground), lineWidth: 1)
                                .background(Rectangle().fill(Color.init(UIColor.label)))
                            .frame(width: geo.size.width * ratio, alignment: .center)
                            .accessibilityElement()
                            .accessibilityLabel( formatter.makeDisplayText(from: clust, asHeader: clust === tabPage.headerCluster, withStringNames: stringNames) )
                    } //fe
                    } //hs
                } //geo
    } //func
    var body: some View {
        List {
        ForEach( tab.pages) {page in
            Section(header: Text(page.title)) {
                    putPage3(tabPage: page)
                        .frame(maxWidth: .infinity, idealHeight: 100, maxHeight: 100, alignment: .topLeading)
            } //se
        } //fe
        } //ls
    } //body
} //str
