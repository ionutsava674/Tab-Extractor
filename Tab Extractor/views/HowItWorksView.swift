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
            VStack(alignment: .leading, spacing: 12) {
                Text("In your web browser, when you are on the page with the tab that you wish to read, simply copy the address from the address bar.")
                Text("Then, come back here in Tab Extractor, and tap “Add from web” on the bottom.")
                Text("In the next dialog, the address will be automatically pasted and the web page content will be scanned.")
                Text("If there are guitar tabs detected, a new dialog will appear, where you will have the options to rename or save these tabs.")
                Text("For example, if these are different versions of the same song, you can choose to save each tab as a song.")
                Text("Otherwise, if they are different sections of the same song, you can rename each one as intro, chorus, verse etc… and then choose to save all tabs as one song.")
                Text("After saving, you can go back to the main screen of the app, where all your saved songs are listed. Select your song from the list for a friendly and accessible navigation of the tab.")
            } //vs
            .navigationTitle("How it works")
        } //nv
    } //body
} //str

struct HowItWorksView_Previews: PreviewProvider {
    static var previews: some View {
        HowItWorksView()
    }
}
