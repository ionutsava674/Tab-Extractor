//
//  EditValueView.swift
//  Tab Extractor
//
//  Created by Ionut on 17.06.2021.
//

import SwiftUI

struct EditValueView: View {
    let editTitle: String
    @Binding var editValue: String
    @Binding var editOKayed: Bool
    @Environment(\.presentationMode) var premo
    @FocusState private var editIsFocused: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 32 , content: {
            TextField(editTitle, text: $editValue, onCommit: {
                submit()
            }) //tf
            .keyboardType(.default)
            .focused($editIsFocused)
            .submitLabel(.done)
            .onAppear {
                self.editIsFocused = true
                //print("focusing")
            }
            HStack {
                Spacer()
                Button("ok") {
                    submit()
                }
                //.disabled( self.editValue.isEmpty)
                Button("cancel") {
                    self.premo.wrappedValue.dismiss()
                }
            } //hs
            .font(.title)
        }) //vs
    } //body
    func submit() -> Void {
        self.editOKayed = true
        self.premo.wrappedValue.dismiss()
    }
} // struct
