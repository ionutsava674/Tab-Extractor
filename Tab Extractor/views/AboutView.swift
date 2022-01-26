//
//  AboutView.swift
//  Tab Extractor
//
//  Created by Ionut on 26.01.2022.
//

import SwiftUI

struct AboutView: View {
    //@AccessibilityFocusState private var headerFocused: Bool
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 8) {
                Text("Tab Extractor")
                    .font(.title)
                    //.accessibilityFocused($headerFocused)
                Text("Very accessible guitar tabs")
                    .font(.headline)
                Text("Tab Extractor is a tool that helps visually impaired people to read guitar tabs more easily.")
                Text("""
    Usually guitar tabs are very hard to access using screen readers.
    Tab extractor makes it easy and fun to read and navigate guitar tabs by laying out the information in a list form, position by position.
    """) //text
                Text("Of course, Tab Extractor can be used by everyone, including sighted persons, by having tabs displayed in original format, so that tabs can be easily shared with friends.")
                Group {
                Text("Main features:")
                Text("automatically detects guitar tabs on a web page")
                Text("lets you save each tab individually or all together")
                Text("lets you customise the way the information is formatted")
                Text("All it requires is that the tabs are correctly formatted and aligned.")
                    
                } //gr
                Group {
                    NavigationLink("How it works") {
                        HowItWorksView()
                    }
                    NavigationLink("Troubleshoot") {
                        TroubleshootView()
                    }
                } //gr
            } //vs
            .padding()
            .navigationTitle("About")
        } //nv
    } //body
} //str

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
