//
//  YourSongsView.swift
//  Tab Extractor
//
//  Created by Ionut on 23.06.2021.
//

import SwiftUI
import UIKit

struct YourSongsView: View {
    @Environment(\.horizontalSizeClass) var hSizeClass
        @State private var showingNewTabUrl = false
    @State private var showingNewTabUrlPD = false
    @State private var newTabUrlPD = "https://ionutsava674.github.io/Tab-Extractor/amazinggrace.html"
    @State private var showingNewTabFromText = false
        @State private var ssl = false
        @State private var docFiles = [TabFileAssoc]()
        @State private var docFilesFiltered: [TabFileAssoc] = []
        @State private var searchFilter = ""
        @State private var filterCount = 0
    
    @State private var listSelection: URL?
    @State private var showDeleteConfirmation = false
    @State private var tfaToDelete: TabFileAssoc?
        
        func filter(_ cfc: Int) -> Void {
            guard cfc == filterCount else {
                return
            }
            guard !searchFilter.isEmpty else {
                docFilesFiltered = docFiles.map({ tfa in
                    tfa
                })
                return
            }
            docFilesFiltered = docFiles.filter { tfa in
                tfa.tab.title.lowercased().contains(searchFilter.lowercased())
            }
        }
        var body: some View {
            let filterBind = Binding<String> {
                searchFilter
            } set: { newVal in
                searchFilter = newVal
                filterCount += 1
                filterCount %= 1000
                let cfc = filterCount
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    filter( cfc)
                }
            }

            return GeometryReader { geo in
            NavigationView {
            VStack {
                TextField(NSLocalizedString("filter", comment: "main window search filter caption 2"), text: filterBind)
                ZStack {
                List {
                ForEach(docFilesFiltered, id: \.fileUrl) {tfa in
                    NavigationLink(tag: tfa.fileUrl,
                                   selection: self.$listSelection,
                                   destination: {
                        MainTabViewer(tab: tfa.tab)
                    },
                                   label: {
                        Text(tfa.tab.title)
                            .lineLimit(2)
                            .font(.headline.bold())
                            .padding(4)
                    }) //navlink
                        .swipeActions(content: {
                            Button(role: .destructive) {
                                self.tfaToDelete = tfa
                                self.showDeleteConfirmation = true
                            } label: {
                                Label(String.localizedStringWithFormat(NSLocalizedString("delete %@", comment: "main screen menu"), tfa.tab.title), systemImage: "trash.fill")
                            } //btn
                        }) //swipe
                    //.font(.headline)
                } //fe
//                .onDelete(perform: deleteItems)
                } //ls
                    if docFiles.isEmpty {
                        VStack {
                            Text("You have no songs in the list.")
                            Button("Add a public domain song to get you started") {
                                //UIPasteboard.general.
                                    self.showingNewTabUrlPD = true
                            }
                        }
                    }
                } //zs
                HStack {
                    NavigationLink {
                        HowToUseMainView()
                    } label: {
                        Label(NSLocalizedString("How to use", comment: "how to use main screen button"), systemImage: "questionmark.diamond")
                    }
                    .padding(.horizontal)
                    Spacer()
                    Button(NSLocalizedString("Refresh list", comment: "main window list refresh button")) {
                        listDocFiles()
                    } //btn
                    .padding(.horizontal)
                } //hs
                HStack {
                    Button {
                        showingNewTabUrl = true
                    } label: {
                            Image(systemName: "doc.badge.plus").renderingMode(.original)
                            .font(.largeTitle)
                    } //btn
                    //.padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .contentShape(Rectangle())
                    .accessibilityLabel(NSLocalizedString("Add from web", comment: "main window web add button"))
                    .accessibility(hint: Text(NSLocalizedString("opens browser", comment: "main window add button hint")))
                    //Spacer()
                    //Spacer()
                    Button {
                        showingNewTabFromText = true
                    } label: {
                            Image(systemName: "note.text.badge.plus").renderingMode(.original)
                            .font(.largeTitle)
                    } //btn
                    //.padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .contentShape(Rectangle())
                    .accessibilityLabel(NSLocalizedString("Add text directly", comment: "main window add text button"))
                    .accessibility(hint: Text(NSLocalizedString("you can paste text directly", comment: "main window add text button hint")))
                    //Spacer()
                } //hs
                .padding(.bottom)
            } //vs
            .onAppear(perform: {
                DispatchQueue.main.async {
                    listDocFiles()
                } //as
            }) //onapp
            .navigationTitle(LCLZ.yourSavedSongs)
            .navigationBarTitleDisplayMode(.large)
                Color(UIColor.systemBackground)
            } //nv
            .chooseStyle(horizontalSizeClass: hSizeClass, geo: geo )
            .alert(NSLocalizedString("Warning. This action is irreversible.", comment: "main screen alert"), isPresented: self.$showDeleteConfirmation, presenting: self.tfaToDelete, actions: { tfatd in
                Button(role: ButtonRole.destructive, action: {
                    _ = self.deleteItem( tfa: tfatd)
                }, label: {
                    Text("Delete")
                })
            }, message: { tfatd in
                Text("Delete \(tfatd.tab.title) ?")
            }) //alert
            } //geo
            .sheet(isPresented: $showingNewTabUrl, onDismiss: {
                listDocFiles()
            }, content: {
                NewTabUrlContent(initialAddress: "",
                                 autoFetchClipBoard: true,
                                    browseAutomatically: true)
        })
            .sheet(isPresented: $showingNewTabUrlPD, onDismiss: {
                listDocFiles()
            }, content: {
                NewTabUrlContent(initialAddress: self.newTabUrlPD,
                                 autoFetchClipBoard: false,
                                    browseAutomatically: true)
        })
            .sheet(isPresented: $showingNewTabFromText, onDismiss: {
                listDocFiles()
            }, content: {
                                    NewTabFromTextContent()
        })
        } //body
    
    func deleteItem(tfa: TabFileAssoc) -> Bool {
        if let _ = try? FileManager.default.removeItem( at: tfa.fileUrl) {
            listDocFiles()
            return true
        }
        return false
    } //func
        func deleteItems(indices: IndexSet) -> Void {
            for index in indices {
                let tfa = docFilesFiltered[index]
                try? FileManager.default.removeItem( at: tfa.fileUrl)
            }
            listDocFiles()
        } //func
        func listDocFiles() -> Void {
            self.docFiles = []
            let du = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            do {
                let fl = try FileManager.default.contentsOfDirectory(at: du[0], includingPropertiesForKeys: nil, options: [])
                for u in fl {
                    guard u.pathExtension.lowercased() == TabFileAssoc.defaultFileExtension.lowercased() else {
                        continue
                    }
                    if let tfa = TabFileAssoc.getFromFile(fileUrl: u) {
                        self.docFiles.append(tfa)
                    } else {
                        //print("no good file")
                    }
                } //for
            } catch {
                //
            }
            self.filter(self.filterCount)
        } //func
    } //struct

extension NavigationView {
    @ViewBuilder
    func chooseStyle(horizontalSizeClass: UserInterfaceSizeClass?, geo: GeometryProxy) -> some View {
        //print(con)
        if horizontalSizeClass == .regular
            && geo.size.width > geo.size.height {
            self.navigationViewStyle(DoubleColumnNavigationViewStyle())
        } else {
            self.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
