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
                            Label(LCLZ.preferencesTab, systemImage: "gearshape.fill")
                        }
                        .tag(2)
            Text("nothing yet")
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
                .tag(3)
                }) //tv
    } //body
} //str
