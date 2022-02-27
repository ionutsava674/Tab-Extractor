//
//  lclz.swift
//  Tab Extractor
//
//  Created by Ionut on 23.06.2021.
//

import Foundation

enum LCLZ {
    static var yourSavedSongs: String {
        NSLocalizedString("Your saved songs", comment: "page title for main song list")
    }
    static let preferencesTab = NSLocalizedString("Preferences", comment: "preferences tab button caption")
    static let aboutTab = NSLocalizedString("About", comment: "About tab button caption")
}
