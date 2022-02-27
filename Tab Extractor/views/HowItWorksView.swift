//
//  HowItWorksView.swift
//  Tab Extractor
//
//  Created by Ionut on 26.01.2022.
//

import SwiftUI

struct HowItWorksView: View {
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 4) {
                Text("1. To add tabs from a web page:")
                Group {
                    Text("In your web browser, when you are on the page with the tab that you wish to read, simply copy the address from the address bar.")
                    Text("Then, come back here in Tab Extractor, and tap “Add from web” on the bottom.")
                    Text("In the next dialog, the address will be automatically pasted and the web page content will start scanning.")
                    Text("This dialog also contains an integrated web browser.")
                    Text("If there are guitar tabs detected, another dialog will appear, where you will have the options to rename or save these tabs.")
                    Text("For example, if these are different versions of the same song, you can choose to save each tab as a song.")
                    Text("Otherwise, if they are different sections of the same song, you can rename each one as intro, chorus, verse etc… and then choose to save all tabs as one song.")
                    Text("After saving, you can go back to the main screen of the app, where all your saved songs are listed. Select your song from the list for a friendly and accessible navigation of the tab.")
                }
                .padding(8)
                Text("2. To add tabs directly by text:")
                Group {
                    Text("If you have your tab in an email or message, or somewhere like that, simply copy that text to the clipboard")
                    Text("Then, in tab-extractor, click \"add text directly\", and a dialog with a text editor will appear.")
                    Text("The clipboard should be automatically pasted here.")
                    Text("If not, you should paste the text here and then click detect.")
                }
                .padding()
            } //vs
                .font(.body)
                .padding()
            } //sv
            .navigationBarTitle("How it works")
            //.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        } //nv
        .navigationBarTitleDisplayMode(.inline)
    } //body
} //str

struct HowItWorksView_Previews: PreviewProvider {
    static var previews: some View {
        HowItWorksView()
    }
}
