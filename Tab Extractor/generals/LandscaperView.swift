//
//  LandscaperView.swift
//  Tab Extractor
//
//  Created by Ionut on 21.03.2022.
//

import SwiftUI

struct LandscaperView<ContentType>: View where ContentType: View {
    var content: () -> ContentType
    @Environment(\.horizontalSizeClass) var hSizeClass
    @Environment(\.verticalSizeClass) var vSizeClass
    func targetWidth(geo: GeometryProxy) -> CGFloat {
        shouldSwitchToPortrait(geo: geo)
        ? geo.size.height / geo.size.width * geo.size.height
        : geo.size.width
    } //func
    func shouldSwitchToPortrait(geo: GeometryProxy) -> Bool {
        if hSizeClass == .regular {
            return geo.size.width > geo.size.height
        }
        return false
    } //func
    var body: some View {
        GeometryReader { geo in
            content()
                //.conditionalFrame(condition: shouldSwitchToPortrait(geo: geo), width: geo.size.height / geo.size.width * geo.size.height, height: geo.size.height, align: .center)
                .frame(width: targetWidth(geo: geo), height: geo.size.height, alignment: .center)
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        } //geo
    } //body
} //str
extension View {
    @ViewBuilder
    func conditionalFrame(condition: Bool, width: CGFloat, height: CGFloat, align: Alignment) -> some View {
        if condition {
            self
                .frame(width: width, height: height, alignment: align)
        } else {
            self
        }
    }
}

struct LandscaperView_Previews: PreviewProvider {
    static var previews: some View {
        LandscaperView() {
            Text("")
        }
    }
}
