//
//  LineSelector.swift
//  Tab Extractor
//
//  Created by Ionut on 08.06.2021.
//

import SwiftUI

struct LineSelector: View {
    let linesToShow: ArraySlice<String>
    var body: some View {
        NavigationView {
            List(linesToShow.startIndex..<linesToShow.endIndex) { idx in
                Text("\(idx) \(self.linesToShow[idx])")
        } // ls
        .navigationTitle("select the start line")
        } //nv
    } //body
}

struct LineSelector_Previews: PreviewProvider {
    static var previews: some View {
        LineSelector(linesToShow: [])
    }
}
