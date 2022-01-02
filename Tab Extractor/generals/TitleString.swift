//
//  TitleString.swift
//  Tab Extractor
//
//  Created by Ionut on 28.12.2021.
//

import Foundation

extension String {
    func limitToTitle( of length: Int) -> String {
        String(
        self.replacingOccurrences( of: "\r\n", with: "")
            .replacingOccurrences( of: "\n", with: "")
            .trimmingCharacters( in: .whitespaces)
            .prefix(length)
        )
    } //func
} //ext
