//
//  PreferencesClass.swift
//  Tab Extractor
//
//  Created by Ionut on 25.06.2021.
//

import Foundation
import SwiftUI

class GlobalPreferences2: ObservableObject {
    @AppStorage("endOfLine") var endOfLine = "\n"
    
    @AppStorage("showZeroResultsFound2") var showZeroResultsFound2 = true
    @AppStorage("showZeroResultsFound") var showZeroResultsFound = true
    @AppStorage("showNavHint1") var showNavHint1 = true
    
    @AppStorage("viewSourceLines") var viewSourceLines = false

    @AppStorage("viewHorizontally") var viewHorizontally = true

    @AppStorage("includeHeader") var includeHeader = true
    @AppStorage("stringStringSeparator") var stringStringSeparator = " "
    @AppStorage("includeBars") var includeBars = true

    @AppStorage("stringNoteSeparator") var stringNoteSeparator: String = ""
    @AppStorage("noteNoteSeparator") var noteNoteSeparator = ", "

    @AppStorage("noStrings6") var noStrings6 = true
    @AppStorage("noStrings6Names") var noStrings6Names = noStrings6NamesDefault
    static let noStrings6NamesDefault = "e, B, G, D, A, E"
    @AppStorage("noStrings4") var noStrings4 = true
    @AppStorage("noStrings4Names") var noStrings4Names = noStrings4NamesDefault
    static let noStrings4NamesDefault = "G, D, A, E"
    @AppStorage("noStrings7") var noStrings7 = true
    @AppStorage("noStrings7Names") var noStrings7Names = noStrings7NamesDefault
    static let noStrings7NamesDefault = "e, b, G, D, A, E, B"
    
    static let global = GlobalPreferences2()
}
