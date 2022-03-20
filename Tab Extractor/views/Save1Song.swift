//
//  Save1Song.swift
//  Tab Extractor
//
//  Created by Ionut on 13.06.2021.
//

import SwiftUI

struct Save1Song: View {
    //@ObservedObject var TabSELContainer: MSLContainer<GuitarTab.Page>
    @ObservedObject var TabSELContainer: SelectableItemContainer<SelectablePage, GuitarTab.Page>
    @ObservedObject var fromTab: GuitarTab
    @Binding var didSaveTab: Bool
    @State private var songTitle = ""
    @Environment(\.presentationMode) var premo
    @State private var alertTitle = ""
    @State private var alertVisible = false
    @State private var dismissAfterAlert = false
    @FocusState private var editFocused: Bool
    
    private func btnSave() -> Void {
        guard !songTitle.isEmpty else {
            alert(msg: NSLocalizedString("Please enter a title", comment: "save 1 song dialog prompt for empty string"), dismiss: false)
            return
        }
        if saveTab() {
        //self.premo.wrappedValue.dismiss()
            alert(msg: NSLocalizedString("Saved successfully", comment: "save 1 song dialog confirmation message"), dismiss: true)
        } else {
            alert(msg: NSLocalizedString("Unable to save", comment: "save 1 song dialog error message"), dismiss: false)
        }
    }
    private func alert(msg: String, dismiss: Bool) -> Void {
        self.alertTitle = msg
        self.dismissAfterAlert = dismiss
        self.alertVisible = true
    }
    private func saveTab() -> Bool {
        let tts = GuitarTab()
        let selected = self.TabSELContainer.items.filter { msi in
            msi.selected
        }
        guard !selected.isEmpty else {
            return false
        }
        for item in selected {
            tts.pages.append( item.mainItem)
        }
        tts.sourceUrl = fromTab.sourceUrl
        tts.title = self.songTitle
        if let _ = TabFileAssoc.saveTab(tab: tts) {
            self.didSaveTab = true
            return true
        }
        return false
    }
    
    var body: some View {
        //NavigationView {
        VStack(alignment: .trailing, spacing: 35, content: {
            TextField(NSLocalizedString("enter song name", comment: "save 1 song dialog edit box prompt"),
                      text: $songTitle,
                      onCommit: {
                btnSave()
            })
            .submitLabel(.continue)
                .focused($editFocused)
            HStack {
                Button(NSLocalizedString("Save", comment: "save 1 song dialog save button")) {
                    btnSave()
                }
                .disabled( self.songTitle.isEmpty)
                Button(NSLocalizedString("Cancel", comment: "save 1 song dialog cancel button")) {
                    self.premo.wrappedValue.dismiss()
                } //btn
            } //hs
            .font(.title)
        }) //vs
        .alert(isPresented: $alertVisible, content: {
            Alert(title: Text(self.alertTitle), message: nil, dismissButton: .default(Text(
            NSLocalizedString("ok", comment: "save 1 song dialog ok button for alerts")
            ), action: {
                if self.dismissAfterAlert {
                    self.premo.wrappedValue.dismiss()
                }
            }))
        }) //alert
        .onAppear {
            self.songTitle = fromTab.title
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.editFocused = true
            } //as
        } //onap
        //} //nv
    } //body
} //str
