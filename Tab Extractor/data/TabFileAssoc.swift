//
//  TabFileAssoc.swift
//  Tab Extractor
//
//  Created by Ionut on 23.06.2021.
//

import Foundation

struct TabFileAssoc {
    let fileUrl: URL
    let tab: GuitarTab
    
    static let defaultFileExtension = "tab"
    static let defaultFileBase = "newTab"
    
    static func saveTab(tab: GuitarTab) -> URL? {
        guard !tab.pages.isEmpty else {
            return nil
        }
        guard let data = try? JSONEncoder().encode( tab) else {
            return nil
        }
        let du = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)        [0]
        guard let fl = try? FileManager.default.contentsOfDirectory(at: du, includingPropertiesForKeys: nil, options: []) else {
            return nil
        }
        var fileName = "\(defaultFileBase)\(fl.count)"
        var tryCount = 0
        while FileManager.default.fileExists(atPath: du.appendingPathComponent(fileName).appendingPathExtension(defaultFileExtension).path) {
            fileName += "_1"
            tryCount += 1
            if tryCount > 50 {
                return nil
            }
        }
        let ru = du.appendingPathComponent(fileName).appendingPathExtension(defaultFileExtension)
        do {
            try data.write(to: ru)
        } catch {
            return nil
        }
        return ru
    } //func
    
    static func getFromFile(fileUrl: URL) -> TabFileAssoc? {
        guard let data = try? Data(contentsOf: fileUrl) else {
            return nil
        }
        guard let gt = try? JSONDecoder().decode(GuitarTab.self, from: data) else {
            return nil
        }
        return TabFileAssoc(fileUrl: fileUrl, tab: gt)
    } //func
} //tfa
