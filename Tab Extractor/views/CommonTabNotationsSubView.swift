//
//  CommonTabNotationsSubView.swift
//  Tab Extractor
//
//  Created by Ionut on 14.06.2022.
//

import SwiftUI

struct CommonTabNotationsSubView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("A quick summary of the most common Guitar TAB notations:")
            Group {
                Text("• h = hammer-on")
                Text("• p = pull-off")
                Text("• b = bend")
                Text("• / = slide up")
                Text("• \\ = slide down")
                Text("• PM – – – – = palm muting (above or below TAB)")
            } //gr
            Group {
                Text("• ~~~ = vibrato")
                Text("• x = muted hit")
                Text("• <> = natural harmonics")
                Text("• t = tapping")
                Text("• () = grace note or let the note ring out")
            } //gr
            Text("There are many more symbols that can appear in Guitar TAB, but the above covers all of the essentials you are likely to see.")
        } //vs
    }
}

struct CommonTabNotationsSubView_Previews: PreviewProvider {
    static var previews: some View {
        CommonTabNotationsSubView()
    }
}
