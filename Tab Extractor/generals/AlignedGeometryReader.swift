//
//  AlignedGeometryReader.swift
//  Tab Extractor
//
//  Created by Ionut on 03.01.2022.
//

import SwiftUI

struct AlignedGeometryReader<ContentType>: View where ContentType: View {
    var alignment: Alignment
    var content: (GeometryProxy) -> ContentType
    var body: some View {
        GeometryReader { geo in
            content(geo)
                .frame(width: geo.size.width, height: geo.size.height, alignment: alignment)
        } //geo
    } //body
} //str

