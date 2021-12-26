//
//  PreferencesView.swift
//  Tab Extractor
//
//  Created by Ionut on 25.06.2021.
//

import SwiftUI

struct PreferencesView: View {
    @AppStorage( wrappedValue: GLBP.viewSourceLinesDefault, GLBP.viewSourceLines.rawValue) var viewSourceLines
    
    @AppStorage( wrappedValue: GLBP.includeBarsDefault, GLBP.includeBars.rawValue) private var includeBars
    @AppStorage( wrappedValue: GLBP.stringStringSepparatorDefault, GLBP.stringStringSeparator.rawValue) var stringStringSeparator
    @AppStorage( wrappedValue: GLBP.stringNoteSeparatorDefault, GLBP.stringNoteSeparator.rawValue) var stringNoteSeparator
    @AppStorage( wrappedValue: GLBP.noteNoteSeparatorDefault, GLBP.noteNoteSeparator.rawValue) var noteNoteSeparator
    
    //@Environment(\.accessibilityDifferentiateWithoutColor) var diffWithoutColor
    var body: some View {
        VStack(alignment: .center) {
            VStack {
        GeometryReader {geo in
        Form {
            AccessibleCheckBox(checked: self.$viewSourceLines, caption: "Display tabs as original, unprocessed, lines")
            Section(header: Text("How do you want to list each tab content?")) {
                HStack {
                Toggle("Include bars when listing tab content", isOn: self.$includeBars)
                    Spacer()
                }
                    .padding(.vertical)
                HStack {
                    //Text("Separator between string names (E A D G...)")
                    Text(String(format: "Separator between string names (E%1$@A%1$@D%1$@G...)", self.stringStringSeparator))
                    Spacer()
                    TextField("", text: self.$stringStringSeparator) { isEditing in
                        //
                    } onCommit: {
                        //
                    } //tf
                    .limitToMaxWidth(geo: geo, ratio: 0.25)
                } //hs
                .padding(.vertical)
                VStack {
                HStack {
                    Text("Separator between string name and note")
                    Spacer()
                    TextField("", text: self.$stringNoteSeparator) { isEditing in
                        //
                    } onCommit: {
                        //
                    } //tf
                    .limitToMaxWidth(geo: geo, ratio: 0.25)
                } //hs
                    Text(String(format: "Example: G%1$@7", self.stringNoteSeparator))
                } //vs
                .padding(.vertical)
                VStack {
                HStack {
                    Text(String(format: "Separator between notes (D%1$@5%2$@G%1$@7)", self.stringNoteSeparator, self.noteNoteSeparator))
                    Spacer()
                    TextField("", text: self.$noteNoteSeparator) { isEditing in
                        //
                    } onCommit: {
                        //
                    } //tf
                    .limitToMaxWidth(geo: geo, ratio: 0.25)
                } //hs
                    Text(String(format: "Example: D%1$@7%2$@G%1$@5", self.stringNoteSeparator, self.noteNoteSeparator))
                } //vs
                .padding(.vertical)
                Text("Tip: use dots, commas or semicolons to help VoiceOver make longer or shorter pauses.")
            } //sect
        } //fo
        } //geo
        } //vs
        .frame(maxWidth: 480)
    } //vs
    } //body
} //str

extension TextField {
    @ViewBuilder
    func limitToMaxWidth(geo: GeometryProxy, ratio: CGFloat) -> some View {
        self.frame(maxWidth: geo.size.width * ratio)
    }
}
