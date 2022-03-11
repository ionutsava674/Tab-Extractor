//
//  TroubleshootView.swift
//  Tab Extractor
//
//  Created by Ionut on 26.01.2022.
//

import SwiftUI

struct TroubleshootView: View {
    var body: some View {
        //NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sometimes ,tab detection may fail because they are not formatted correctly. If monospaced font isn’t used, the tab lines may appear equal in length, but in fact, they are not.")
                    Text("The best thing to do in this case, is to find a better version. Most tabs out there are formatted and aligned correctly.")
                    Text("Or, you can copy the text, and then have it edited in any simple editor that can use monospaced font. And then add the tab with the \"add text directly\" option in the main screen.")
                    Text("Other times, in rare cases, some tabs may not be properly detected because they are way too close together. Lines and dashes are not hardcoded, instead are detected through density of occurrence. so notations within the lines of the tab should be spaced out a little.")
                } //vs
                    .font(.body)
                    .padding()
                } //sv
                .navigationBarTitle("Troubleshoot")
                .navigationBarTitleDisplayMode(.inline)
            //} //nv
    } //body
} //str

struct TroubleshootView_Previews: PreviewProvider {
    static var previews: some View {
        TroubleshootView()
    }
}
