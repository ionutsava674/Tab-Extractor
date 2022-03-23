//
//  AboutView.swift
//  Tab Extractor
//
//  Created by Ionut on 26.01.2022.
//

import SwiftUI
import MessageUI

struct AboutView: View {
    //@AccessibilityFocusState private var headerFocused: Bool
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    @State private var showingMail = false
    let mailTo = "ionutsava027@gmail.com"
    let mailSubject = "contacting for Tab Extractor"
    var body: some View {
        LandscaperView {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Tab Extractor")
                    .font(.title)
                    //.accessibilityFocused($headerFocused)
                Text("Very accessible guitar tabs")
                    .font(.headline)
                Text("Tab Extractor is a tool created to help visually impaired people to read guitar tabs more easily.")
                Text("""
    Usually guitar tabs are very hard to access using screen readers.
    Tab extractor makes it easy and fun to read and navigate guitar tabs by laying out the information in a list form, position by position.
    """) //text
                Text("Of course, Tab Extractor can be used by everyone, including sighted persons, by having tabs displayed in original format, so that tabs can be easily shared with friends.")
                Group {
                Text("Main features:")
                        .font(.subheadline.bold())
                Text("automatically detects guitar tabs on a web page")
                Text("lets you save each tab individually or all together")
                Text("lets you customise the way the information is formatted")
                Text("All it requires is that the tabs are correctly formatted and aligned.")
                    
                } //gr
                .padding(8)
                Group {
                    NavigationLink(NSLocalizedString("How it works", comment: "link in about")) {
                        HowItWorksView()
                    }
                    NavigationLink(NSLocalizedString("Troubleshoot", comment: "link in about")) {
                        TroubleshootView()
                    }
                    NavigationLink(NSLocalizedString("Privacy", comment: "pr link in about")) {
                        PrivacyView()
                    }
                } //gr
                .padding(8)
                Group {
                    Text("Screen readers are great tools that help us access and also input information.")
                    Text("This entire app was written with the awesome help of Apple's screen-reader, voiceover®.")
                } //gr
                Group {
                    Text("Contact")
                        .font(.subheadline.bold())
                    Text("For suggestions, bugs, critics etc 😅 feel free to drop me an email:")
                    Button(mailTo) {
                        showingMail = true
                    }
                    .disabled(!MFMailComposeViewController.canSendMail())
                    Link(destination: URL(string: "https://ionutsava674.github.io/Tab-Extractor/")!) {
                        Text("Visit the project website on github")
                            .accessibilityLabel(Text("Visit the project website on github."))
                    }
                    .padding()
                } //gr
            } //vs
            .padding()
            } //sv
            .navigationTitle(LCLZ.aboutTab)
            .navigationBarTitleDisplayMode(.large)
        } //nv
        .navigationViewStyle(.stack)
        .sheet(isPresented: $showingMail) {
            //
        } content: {
            MailComposerView(result: self.$mailResult, toRecipient: self.mailTo, subject: self.mailSubject)
        } //mail
        } //ls
    } //body
        
    func openEmail() -> Void {
        if MFMailComposeViewController.canSendMail() {
            //
        }
    } //func
} //str

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
