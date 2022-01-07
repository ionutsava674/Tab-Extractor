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
    
    @AppStorage( wrappedValue: GLBP.includeHeaderDefault, GLBP.includeHeader.rawValue) private var includeHeader
    @AppStorage( wrappedValue: GLBP.stringStringSepparatorDefault, GLBP.stringStringSeparator.rawValue) var stringStringSeparator
    @AppStorage( wrappedValue: GLBP.includeBarsDefault, GLBP.includeBars.rawValue) private var includeBars
    
    @AppStorage( wrappedValue: GLBP.stringNoteSeparatorDefault, GLBP.stringNoteSeparator.rawValue) var stringNoteSeparator
    @AppStorage( wrappedValue: GLBP.noteNoteSeparatorDefault, GLBP.noteNoteSeparator.rawValue) var noteNoteSeparator
    
    @AppStorage( wrappedValue: GLBP.viewHorizontallyDefault, GLBP.viewHorizontally.rawValue) private var viewHorizontally
    
    @AppStorage( wrappedValue: GLBP.noStrings6Default, GLBP.noStrings6.rawValue) var noStrings6
    @AppStorage( wrappedValue: GLBP.noString6NamesDefault, GLBP.noStrings6Names.rawValue) var noStrings6Names
    @AppStorage( wrappedValue: GLBP.noStrings4Default, GLBP.noStrings4.rawValue) var noStrings4
    @AppStorage( wrappedValue: GLBP.noString4NamesDefault, GLBP.noStrings4Names.rawValue) var noStrings4Names
    @AppStorage( wrappedValue: GLBP.noStrings7Default, GLBP.noStrings7.rawValue) var noStrings7
    @AppStorage( wrappedValue: GLBP.noString7NamesDefault, GLBP.noStrings7Names.rawValue) var noStrings7Names
    //@Environment(\.accessibilityDifferentiateWithoutColor) var diffWithoutColor
    
    var body: some View {
        Form {
            Section(header: Text("How to display tabs")) {
            AccessibleCheckBox(checked: $viewSourceLines, caption: "Display tabs as original, unprocessed, lines")
            } //se
            if !viewSourceLines {
            Picker("Display each tab as", selection: $viewHorizontally) {
                Text("as horizontal list")
                    .tag(true)
                Text("as vertical list")
                    .tag(false)
            } //pk
            .pickerStyle(InlinePickerStyle() )
            //.disabled( self.viewSourceLines)
            Section(header: Text("Options for processed tabs:")) {
                HStack {
                Toggle("Include header line (the string names at the beginning of the tab)", isOn: self.$includeHeader)
                    Spacer()
                } //hs
                    .padding(.top)
                HStack {
                    Text(String(format: "Separator between string names (E%1$@A%1$@D%1$@G...)", self.stringStringSeparator))
                    Spacer()
                    TextField("", text: self.$stringStringSeparator)
                    .limitToMaxWidth(geo: geo, ratio: 0.25)
                } //hs
                .padding(.vertical)
                HStack {
                Toggle("Include bars when listing tab content", isOn: self.$includeBars)
                    Spacer()
                } //hs
                    .padding(.top)
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
                Section("When string names are missing") {
                    VStack {
                    Toggle("6 strings default", isOn: $noStrings6)
                    TextField(GLBP.noString6NamesDefault, text: $noStrings6Names)
                }.padding(.vertical)
                    VStack {
                    Toggle("4 strings default (bass)", isOn: $noStrings4)
                    TextField(GLBP.noString4NamesDefault, text: $noStrings4Names)
                }.padding(.vertical)
                    VStack {
                    Toggle("7 strings default", isOn: $noStrings7)
                    TextField(GLBP.noString7NamesDefault, text: $noStrings7Names)
                }.padding(.vertical)
                } //se
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
