//
//  PreferencesView.swift
//  Tab Extractor
//
//  Created by Ionut on 25.06.2021.
//

import SwiftUI

struct InnerPreferencesView: View {
    var geo: GeometryProxy
    
    @AppStorage( wrappedValue: GLBP.viewSourceLinesDefault, GLBP.viewSourceLines.rawValue) var viewSourceLines
    
    @AppStorage( wrappedValue: GLBP.includeBarsDefault, GLBP.includeBars.rawValue) private var includeBars
    @AppStorage( wrappedValue: GLBP.stringStringSepparatorDefault, GLBP.stringStringSeparator.rawValue) var stringStringSeparator
    @AppStorage( wrappedValue: GLBP.stringNoteSeparatorDefault, GLBP.stringNoteSeparator.rawValue) var stringNoteSeparator
    @AppStorage( wrappedValue: GLBP.noteNoteSeparatorDefault, GLBP.noteNoteSeparator.rawValue) var noteNoteSeparator
    
    @AppStorage( wrappedValue: GLBP.viewHorizontallyDefault, GLBP.viewHorizontally.rawValue) private var viewHorizontally
    //@Environment(\.accessibilityDifferentiateWithoutColor) var diffWithoutColor
    
    var body: some View {
        Form {
            Section(header: Text("How to display tabs")) {
            AccessibleCheckBox(checked: $viewSourceLines, caption: "Display tabs as original, unprocessed, lines")
                //Toggle("Display tabs as original, unprocessed, lines", isOn: self.$viewSourceLines)
            } //se
            if !viewSourceLines {
            Picker("Display each tab as", selection: $viewHorizontally) {
                Text("as horizontal list")
                    .tag(true)
                Text("as vertical list")
                    .tag(false)
            } //pk
            .pickerStyle(InlinePickerStyle() )
            .disabled( self.viewSourceLines)
            Section(header: Text("Options for processed tabs:")) {
                HStack {
                Toggle("Include bars when listing tab content", isOn: self.$includeBars)
                    Spacer()
                } //hs
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
                    TextField("", text: self.$stringNoteSeparator)
                    .limitToMaxWidth(geo: geo, ratio: 0.25)
                } //hs
                    Text(String(format: "Example: G%1$@7", self.stringNoteSeparator))
                } //vs
                .padding(.vertical)
                VStack {
                HStack {
                    Text("Separator between notes")
                    Spacer()
                    TextField("", text: self.$noteNoteSeparator)
                    .limitToMaxWidth(geo: geo, ratio: 0.25)
                } //hs
                    Text(String(format: "Example: D%1$@7%2$@G%1$@5", self.stringNoteSeparator, self.noteNoteSeparator))
                } //vs
                .padding(.vertical)
                Text("Tip: use dots, commas or semicolons to help VoiceOver make longer or shorter pauses.")
            } //sect
            } //if processed
        } //fo
        .padding(.bottom)
        .keyboardType(.numbersAndPunctuation)
        .submitLabel(.done)
    } //body
} //str
struct PreferencesView: View {
    var body: some View {
        GeometryReader {geo in
            InnerPreferencesView(geo: geo)
        } //geo
        .frame(maxWidth: 480)
    } //body
} //str

extension TextField {
    @ViewBuilder
    func limitToMaxWidth( geo: GeometryProxy, ratio: CGFloat) -> some View {
        self
            .frame(maxWidth: geo.size.width * ratio)
    } //func
} //ext
extension View {
    @ViewBuilder
    func optionalHidden(condition: Bool) -> some View {
        if condition {
            self
            .hidden()
        } else {
            self
        }
    } //func
} //ext
