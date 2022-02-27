//
//  TabViewerHelpView.swift
//  Tab Extractor
//
//  Created by Ionut on 12.01.2022.
//

import SwiftUI

struct TabViewerHelpView: View {
    @Environment(\.presentationMode) var premo
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 4) {
                    Button("back") {
                        premo.wrappedValue.dismiss()
                    }.padding()
                Group {
                    Text("To make it easier to go over a portion of the song a few times over, you can mark a position by performing a long press over it.")
                    Text("In voiceover this is a triple tap or a double tap and hold.")
                    Text("then go over the song portion by swiping right.")
                    Text("Then, when you want to go back to the marked position, just perform a double tap wherever, and the focus will jump back to the marked position.")
                } //g
                .padding(8)
                Group {
                    Text("The recommended mode for voiceover users is horizontal list. You can find this option in preferences.")
                    Text("In this way, each position of the tab is a rectangle shape, and when you drag the finger over it, its value will be spoken.")
                    Text("This value consists of the guitar-string name (E A D G etc), and the fret value.")
                    Text("This fret value can be a number (like 8 or 10 or 0 for open strings), or something like 8s10 for example for a slide from 8 to 10.")
                    Text("Or if the position has more than one strings that should be played at the same time, it will be something like A2 D4 G4.")
                } //g
                .padding()
                    Button("OK") {
                        premo.wrappedValue.dismiss()
                    }
                    .padding()
                    .font(.title.bold())
                    .frame(maxWidth: .infinity, alignment: .trailing)
            } //vs
                .font(.body)
                .padding()
            } //sv
            .navigationBarTitle("Navigation help")
            //.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        } //nv
        .navigationBarTitleDisplayMode(.inline)
    } //body
} //str

struct TabViewerHelpView_Previews: PreviewProvider {
    static var previews: some View {
        TabViewerHelpView()
    }
}
