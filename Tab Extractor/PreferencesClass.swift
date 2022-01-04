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
    case includeBars
    static let includeBarsDefault = true
    case stringStringSeparator
    static let stringStringSepparatorDefault = " "
    case stringNoteSeparator
    static let stringNoteSeparatorDefault: String = ""
    case noteNoteSeparator
    static let noteNoteSeparatorDefault = ", "
    
    case viewHorizontally
    static let viewHorizontallyDefault = true
}
typealias GLBP = GlobalPreferences
