//
//  RatingRequester.swift
//  Tab Extractor
//
//  Created by Ionut on 14.06.2022.
//

import Foundation
import StoreKit

class RatingRequester {
    static let launchCountKey = "LaunchCount"
    static let launchCountVersionKey = "LaunchCountVersion"
    static let globalInstance = RatingRequester()
    
    var alreadyRequestedThisInstance = false
    
    static func increaseLaunchCount() -> Void {
        let curVersionKey = kCFBundleVersionKey as String
        guard let curVersion = Bundle.main.object(forInfoDictionaryKey: curVersionKey) as? String else {
            return
        }
        let lastVersion = UserDefaults.standard.string(forKey: Self.launchCountVersionKey)
        var curCount = 1
        if curVersion == lastVersion {
            curCount = UserDefaults.standard.integer(forKey: Self.launchCountKey) ?? 0
            curCount += 1
        }
        defer {
            UserDefaults.standard.set(curCount, forKey: Self.launchCountKey)
            if curVersion != lastVersion {
                UserDefaults.standard.set(curVersion, forKey: Self.launchCountVersionKey)
            }
        } //def
        //print("curcount \(curCount) ver \(curVersion)")
    } //func
    func requestRating( afterNumberOfLaunches minLaunchCount: Int) -> Void {
        guard !alreadyRequestedThisInstance else {
            return
        }
        let launchCount = UserDefaults.standard.integer(forKey: Self.launchCountKey) ?? 0
        guard launchCount >= minLaunchCount else {
            return
        } //gua
        alreadyRequestedThisInstance = true
        SKStoreReviewController.requestReview()
    } //func
} //class
