//
//  IncomingShare.swift
//  Tab Extractor
//
//  Created by Ionut on 15.06.2021.
//

import Foundation
import SwiftUI

class ExampleActivity: UIActivity {
    var _activityTitle: String
    var _activityImage: UIImage
    var _activityItems = [Any]()
    var _action: ([Any]) -> Void
    
    init( title: String, image: UIImage, performAction: @escaping ([Any]) -> Void) {
        _activityTitle = title
        _activityImage = image
        _action = performAction
        super.init()
    }
    override var activityTitle: String? {
        _activityTitle
    }
    override var activityImage: UIImage? {
        _activityImage
    }
    override var activityType: UIActivity.ActivityType? {
        UIActivity.ActivityType(rawValue: "com.saio.tabextractor.shareactivity")
    }
    override class var activityCategory: UIActivity.Category {
        .action
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        if let _ = activityItems as? [URL] {
            return true
        }
        return true
    }
    override func prepare(withActivityItems activityItems: [Any]) {
        self._activityItems = activityItems
    }
    override func perform() {
        _action( _activityItems)
        activityDidFinish( true)
    }
} //class
