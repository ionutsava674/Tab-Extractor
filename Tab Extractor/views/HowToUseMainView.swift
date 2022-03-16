//
//  HowToUseMainView.swift
//  Tab Extractor
//
//  Created by Ionut on 16.03.2022.
//

import SwiftUI

struct HowToUseMainView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 4) {
            Text("To add tabs from a web page:")
            Group {
                Text("1. Go to the web page that contains the tablature you want, using any browser.")
                Text("2. Copy the address.")
                Text("3. Then, come back here in Tab Extractor, and tap “Add from web”, on the bottom left.")
                Text("From there, everything should be automatic.")
                Text("In the next dialog, the address will be automatically pasted and the web page content will start scanning.")
                Text("This dialog also contains an integrated web browser.")
                Text("If there are guitar tabs detected, another dialog will appear, where you will have the options to rename or save these tabs.")
                Text("For example, if these are different versions of the same song, you can choose to save each tab as a song.")
                Text("Otherwise, if they are different sections of the same song, you can rename each one as intro, chorus, verse etc… and then choose to save all tabs as one song.")
                Text("After saving, you can go back to the main screen of the app, where all your saved songs are listed. Select your song from the list for a friendly and accessible navigation of the tab.")
            }
            .padding(8)
        } //vs
            .font(.body)
            .padding()
        } //sv
        .navigationBarTitle("How to use")
        .navigationBarTitleDisplayMode(.inline)
    } //body
} //str

struct HowToUseMainView_Previews: PreviewProvider {
    static var previews: some View {
        HowToUseMainView()
    }
}
