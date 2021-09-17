//
//  AccessibleCheckBox.swift
//  Tab Extractor
//
//  Created by Ionut on 16.06.2021.
//

import SwiftUI

struct AccessibleCheckBox: View {
    @Binding var checked: Bool
    var caption: String
    var body: some View {
        HStack {
            Image(systemName: checked ? "checkmark.square" : "square")
            Text(caption)
        } //hs
        .accessibilityElement(children: .ignore)
        .accessibility(hint: Text("double tap to toggle"))
        .accessibility(label: Text(caption))
        .accessibility(value: Text(self.checked ? "checked" : "unchecked"))
        .onTapGesture(perform: {
            self.checked.toggle()
        })
    }
} //struct

struct AccessibleCheckBox_Previews: PreviewProvider {
    static var previews: some View {
        AccessibleCheckBox( checked: .constant( true), caption: "CheckBox")
    }
}
