//
//  TitleString.swift
//  Tab Extractor
//
//  Created by Ionut on 28.12.2021.
//

import Foundation

extension String {
    func changeToFileNameLegal() -> Self {
        let illegalFileNameChars: [String] = ["/", "\\", "?", ":", "\""]
        var result = self
        for char in illegalFileNameChars {
            if result.contains( char) {
                result = result.replacingOccurrences(of: char, with: " ")
            }
        }
        return result
    } //func
    func limitToTitle( of length: Int) -> String {
        String(
        self.replacingOccurrences( of: "\r\n", with: "")
            .replacingOccurrences( of: "\n", with: "")
            .trimmingCharacters( in: .whitespaces)
            .prefix(length)
        )
    } //func
} //ext
