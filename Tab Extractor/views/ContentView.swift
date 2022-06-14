//
//  ContentView.swift
//  Tab Extractor
//
//  Created by Ionut on 30.05.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var mainTabSelection = 1
    
    var body: some View {
        TabView(selection: $mainTabSelection,
                content:  {
                    YourSongsView()
                        .tabItem {
                            Label(LCLZ.yourSavedSongs, systemImage: "music.note.list")
                            //Text(LCLZ.yourSavedSongs)
                        }
                        .tag(1)
                    
                    PreferencesView()
                        .tabItem {
                            Label(LCLZ.preferencesTab, systemImage: "tuningfork")
                            //Label(LCLZ.preferencesTab, systemImage: "gearshape")
                        }
                        .tag(2)
            AboutView()
                .tabItem {
                    //Label("About", systemImage: "info.circle")
                    Label(LCLZ.aboutTab, systemImage: "hand.point.up")
                        //.accessibilityElement()
                }
                .tag(3)
                }) //tv
        .onAppear {
            RatingRequester.increaseLaunchCount()
        } //onapp
    } //body
} //str
