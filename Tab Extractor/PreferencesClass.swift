//
//  PreferencesClass.swift
//  Tab Extractor
//
//  Created by Ionut on 25.06.2021.
//

import Foundation
import SwiftUI

enum GlobalPreferences: String {
    case viewSourceLines
    static let viewSourceLinesDefault = false
    
    case includeHeader
    static let includeHeaderDefault = true
    case stringStringSeparator
    static let stringStringSepparatorDefault = " "
    case includeBars
    static let includeBarsDefault = true
    
    case stringNoteSeparator
    static let stringNoteSeparatorDefault: String = ""
    case noteNoteSeparator
    static let noteNoteSeparatorDefault = ", "
    
    case viewHorizontally
    static let viewHorizontallyDefault = true
    
    case noStrings6
    static let noStrings6Default = true
    case noStrings6Names
    static let noString6NamesDefault = "e, B, G, D, A, E"
    case noStrings4
    static let noStrings4Default = true
    case noStrings4Names
    static let noString4NamesDefault = "G, D, A, E"
    case noStrings7
    static let noStrings7Default = true
    case noStrings7Names
    static let noString7NamesDefault = "e, b, G, D, A, E, B"
    
    static let nsn6 = Pref2(defaultValue: true)
}
typealias GLBP = GlobalPreferences

struct Pref2<ValueType> {
    let defaultValue: ValueType
    var settingName: String {
        return String(describing: self)
    }
}
