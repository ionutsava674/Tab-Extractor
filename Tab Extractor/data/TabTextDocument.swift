//
//  TabTextDocument.swift
//  Tab Extractor
//
//  Created by Ionut on 12.01.2022.
//

import Foundation
import UniformTypeIdentifiers
import SwiftUI

struct TabTextDocument: FileDocument {
    static var readableContentTypes: [UTType] = [.plainText]
    var content = ""
    
    init( initialText: String) {
        content = initialText
    } //init
    init( configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            content = String(decoding: data, as: UTF8.self)
        }
    } //init
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(content.utf8)
        return FileWrapper(regularFileWithContents: data)
    } //func
} //str
