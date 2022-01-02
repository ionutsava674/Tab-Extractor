//
//  TouchTabViewer.swift
//  Tab Extractor
//
//  Created by Ionut on 31.12.2021.
//

import SwiftUI

struct TouchTabViewer: View {
    @ObservedObject var tabPage: GuitarTab.Page
    
    func getSizes() -> [CGFloat] {
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
    var body: some View {
        let sizes = getSizes()
        return GeometryReader { geo in
            ForEach(sizes, id: \.self) {size in
                Rectangle()
                    .fill(Color.white)
                    .frame(width: size * geo.size.width, alignment: .center)
                    .accessibilityElement()
                    .accessibilityLabel("note")
            } //fe
        } //geo
    } //body
} //str
