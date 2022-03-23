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

    @AppStorage("includeHeader") var includeHeader = false
    @AppStorage("stringStringSeparator") var stringStringSeparator = " "
    @AppStorage("includeBars") var includeBars = true

    @AppStorage("stringNoteSeparator") var stringNoteSeparator: String = ": "
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
    
    func restoreDefaults() -> Void {
        endOfLine = "\n"
        
        showZeroResultsFound2 = true
        showZeroResultsFound = true
        showNavHint1 = true
        
        viewSourceLines = false

        viewHorizontally = true

        includeHeader = false
        stringStringSeparator = " "
        includeBars = true

        stringNoteSeparator = ": "
        noteNoteSeparator = ", "

        noStrings6 = true
        noStrings6Names = Self.noStrings6NamesDefault

        noStrings4 = true
        noStrings4Names = Self.noStrings4NamesDefault

        noStrings7 = true
        noStrings7Names = Self.noStrings7NamesDefault
    } //func
} //class
