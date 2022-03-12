//
//  PrivacyView.swift
//  Tab Extractor
//
//  Created by Ionut on 12.03.2022.
//

import SwiftUI

struct PrivacyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text("The Tab-Extractor app does not collect, store, use or share any information, personal or otherwise.")
                Text("Everything you save is stored locally on the device.")
                Text("For the complete privacy policy please visit the link below.")
                Link("privacy policy", destination: URL(string: "https://ionutsava674.github.io/Tab-Extractor/privacypolicy.html")!)
            } //vs
                .font(.body)
                .padding()
            } //sv
            .navigationBarTitle("Privacy")
            .navigationBarTitleDisplayMode(.inline)
    } //body
} //str

struct PrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyView()
    }
}
