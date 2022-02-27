//
//  PreferencesView.swift
//  Tab Extractor
//
//  Created by Ionut on 25.06.2021.
//

import SwiftUI

struct InnerPreferencesView: View {
    var geo: GeometryProxy
    
    @ObservedObject private var glop = GlobalPreferences2.global
    
    //@Environment(\.accessibilityDifferentiateWithoutColor) var diffWithoutColor
    
    var body: some View {
        Form {
            Section(header: Text("How to display tabs")) {
                AccessibleCheckBox(checked: $glop.viewSourceLines, caption: NSLocalizedString("Display tabs as original, unprocessed, lines", comment: "preferences checkbox"))
            } //se
            if !glop.viewSourceLines {
                Picker(NSLocalizedString("Display each tab as", comment: "preferences picker"), selection: $glop.viewHorizontally) {
                Text("as horizontal list")
                    .tag(true)
                Text("as vertical list")
                    .tag(false)
            } //pk
            .pickerStyle(InlinePickerStyle() )
            //.disabled( self.viewSourceLines)
            Section(header: Text("Options for processed tabs:")) {
                HStack {
                    Toggle(NSLocalizedString("Include header line (the string names at the beginning of the tab)", comment: "prefs radio box"), isOn: self.$glop.includeHeader)
                    Spacer()
                } //hs
                    .padding(.top)
                HStack {
                    Text(String(format: NSLocalizedString("Separator between string names (E%1$@A%1$@D%1$@G...)", comment: "prefs sep"), glop.stringStringSeparator))
                    Spacer()
                    TextField("", text: $glop.stringStringSeparator)
                    .limitToMaxWidth(geo: geo, ratio: 0.25)
                } //hs
                .padding(.vertical)
                .disabled( !glop.includeHeader)
                HStack {
                    Toggle(NSLocalizedString("Include bars when listing tab content", comment: "prefs radio"), isOn: self.$glop.includeBars)
                    Spacer()
                } //hs
                    .padding(.top)
            } // se
                Section(NSLocalizedString("on each note", comment: "prefs section")) {
                VStack {
                HStack {
                    Text("Separator between string name and note")
                    Spacer()
                    TextField("", text: self.$glop.stringNoteSeparator)
                    .limitToMaxWidth(geo: geo, ratio: 0.25)
                } //hs
                    Text(String(format: NSLocalizedString("Example: G%1$@7", comment: "string note sep example"), glop.stringNoteSeparator))
                } //vs
                .padding(.vertical)
                VStack {
                HStack {
                    Text("Separator between notes")
                    Spacer()
                    TextField("", text: $glop.noteNoteSeparator)
                    .limitToMaxWidth(geo: geo, ratio: 0.25)
                } //hs
                    Text(String(format: NSLocalizedString("Example: D%1$@7%2$@G%1$@5", comment: "not note sep example"), glop.stringNoteSeparator, glop.noteNoteSeparator))
                } //vs
                .padding(.vertical)
                Text("Tip: use dots, commas or semicolons to help VoiceOver make longer or shorter pauses.")
            } //sect
                /*
                Section(NSLocalizedString("When string names are missing", comment: "missing section")) {
                    VStack {
                        Toggle("6 strings default", isOn: $glop.noStrings6)
                        TextField(GlobalPreferences2.noStrings6NamesDefault, text: $glop.noStrings6Names)
                }.padding(.vertical)
                    VStack {
                        Toggle("4 strings default (bass)", isOn: $glop.noStrings4)
                        TextField(GlobalPreferences2.noStrings4NamesDefault, text: $glop.noStrings4Names)
                }.padding(.vertical)
                    VStack {
                        Toggle("7 strings default", isOn: $glop.noStrings7)
                        TextField(GlobalPreferences2.noStrings7NamesDefault, text: $glop.noStrings7Names)
                }.padding(.vertical)
                } //se
                 */
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
