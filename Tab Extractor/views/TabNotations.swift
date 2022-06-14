//
//  TabNotations.swift
//  Tab Extractor
//
//  Created by Ionut on 14.06.2022.
//

import SwiftUI

struct TabNotations: View {
    @AccessibilityFocusState private var firstFocused: Bool
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 4) {
            Text("Here is a quick guide to the most common symbols you will see in text-based Guitar TAB:")
                    .accessibilityFocused($firstFocused)
            Group {
                Text("‘h‘ in Guitar TAB is short for ‘hammer-on’. This is when you play a note and hammer-on to a higher note.")
                Text("2h4 means play the 2nd fret, then hammer-on to the 4th fret. 2h4h5 means to do two hammer-ons in a row (you only pick the first note).")
                Text("‘p‘ in Guitar TAB is short for ‘pull-off’. This is when you play a note and pull-off to a lower note.")
                Text("It’s basically the opposite of a hammer-on.")
                Text("A slash ( / ) or backslash ( \\ ) in Guitar TAB is the symbol for a slide.")
                Text("The type of slash used tells you whether you need to slide up to a note ‘/’ or slide down to a note")
                Text("old text-based Guitar TAB may show s instead of a slash (eg: 7s5).")
                Text("‘b‘ in Guitar TAB is the symbol for a bend.")
                Text("In text-based Guitar TAB, sometimes a number is given after the ‘b’ to tell us what pitch to bend up to. So 7b9 means to bend the 7th fret note up until it sounds like the 9th fret pitch.")
                Text("Some older text-based Guitar TAB found online use the symbol ^ to represent a bend.")
            } //gr
                Group {
                    Text("‘r‘ in Guitar TAB means to release a bend. Sometimes this is shown if a bend needs to be held for a long time, so you know when to lower it again.")
                    Text("‘pb’ in Guitar TAB means to pre-bend a note before you pick it. You push the string up to the correct pitch, then pick the note before releasing it or holding it.")
                    Text("‘x‘ in Guitar TAB is the symbol for a muted hit or rake. This can be across multiple strings or on a single string.")
                    Text("A muted hit is when you lightly place your fingers over the strings and hit them.")
                    Text("When a note is in parentheses () in Guitar TAB, it either means to play a ghost note or that the note is continuing to ring out.")
                    Text("‘~‘ in Guitar TAB is the symbol for vibrato. In text-based Guitar TAB, this is usually displayed on the line next to the note.")
                    Text("Some old text-based Guitar TAB uses v next to the note to show vibrato because the ~~~ can be hard to see.")
                    Text("‘<>‘ in Guitar TAB is the symbol for natural harmonics. When you see a note in between the two symbols such as <12> it means to play a natural harmonic on that fret.")
                    Text("‘t‘ in Guitar TAB is the symbol for tapping. This is sometimes displayed above the staff with a capital T, while other times it is displayed next to the note (usually on text-based TAB).")
                    Text("‘PM‘ in Guitar TAB is the symbol for palm muting. This is usually displayed above or below the staff and is followed by a dashed line if the palm muting is held for a long time.")
                } //gr
                CommonTabNotationsSubView()
                    .padding(8)
        } //vs
            .font(.body)
            .padding()
        } //sv
        .navigationBarTitle("Most common tab notations")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.firstFocused = true
            }
        }
    } //body
} //str

struct TabNotations_Previews: PreviewProvider {
    static var previews: some View {
        TabNotations()
    }
}
