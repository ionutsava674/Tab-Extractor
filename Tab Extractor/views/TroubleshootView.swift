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
        ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sometimes ,tab detection may fail because they are not formatted correctly. If monospaced font isn’t used, the tab lines may appear equal in length, but in fact, they are not.")
                    Text("The best thing to do in this case, is to find a better version. Most tabs out there are formatted and aligned correctly.")
                    Group {
                    Text("Or, you can copy the text, and then have it edited in any simple editor that can use monospaced font. And then add the tab with the \"add text directly\" option in the main screen.")
                    Text("You can edit out anything that is not part of the tab, and leave only the tab lines.")
                    Text("Each line should start with the string name, E, A, G, D, etc . And make sure that all lines have a equal length of characters.")
                        Text("You can do this using the integrated text editor within Tab Extractor, but, while using screen readers, it is way easier to use a full keyboard. You have more navigation control, with arrow keys, home, end, etc.")
                    } //gr
                    Text("In rare cases, some web sites may take a while to load entirely, 10, even 15 seconds or so. The content scanning cannot start until this is done. So, in these rare cases, please be a little patient.")
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
