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
    //@Environment(\.verticalSizeClass) var vSizeClass
    
        @State private var showingNewTabUrl = false
    @State private var showingNewTabUrlPD = false
    @State private var newTabUrlPD = "https://ionutsava674.github.io/Tab-Extractor/amazinggrace.html"
    @State private var showingNewTabFromText = false

        @State private var docFiles = [TabFileAssoc]()
    @State private var docFilesLoaded = false
        //@State private var docFilesFiltered: [TabFileAssoc] = []
    private var docFiles2Filtered: [TabFileAssoc] {
        guard self.docFilesLoaded else {
            return []
        }
        guard !self.searchFilter.isEmpty else {
            return docFiles
            .sorted(by: { tfa1, tfa2 in
                tfa1.tab.title < tfa2.tab.title
            })
        } //gua
        return docFiles.filter { tfa in
            tfa.tab.title.localizedCaseInsensitiveContains( searchFilter)
            // tfa.tab.title.lowercased().contains( searchFilter.lowercased())
        }
        .sorted(by: { tfa1, tfa2 in
            tfa1.tab.title < tfa2.tab.title
        })
    } //cv
        @State private var searchFilter = ""
        //@State private var filterCount = 0
    
    @State private var listSelection: URL?
    @State private var showDeleteConfirmation = false
    @State private var tfaToDelete: TabFileAssoc?
        /*
        func filter(_ cfc: Int) -> Void {
            guard cfc == filterCount else {
                return
            }
            guard !searchFilter.isEmpty else {
                docFilesFiltered = docFiles.map({ tfa in
                    tfa
                })
                .sorted(by: { tfa1, tfa2 in
                    tfa1.tab.title < tfa2.tab.title
                })
                return
            }
            docFilesFiltered = docFiles.filter { tfa in
         tfa.tab.title.localizedCaseInsensitiveContains( searchFilter)
                // tfa.tab.title.lowercased().contains( searchFilter.lowercased())
            }
            .sorted(by: { tfa1, tfa2 in
                tfa1.tab.title < tfa2.tab.title
            })
        } //func
         */
        var body: some View {
            /*
            let filterBind = Binding<String> {
                self.searchFilter
            } set: { newVal in
                self.searchFilter = newVal
                print(newVal, newVal.count)
                filterCount += 1
                filterCount %= 1000
                let cfc = filterCount
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    filter( cfc)
                }
            } //bind
             */

            return GeometryReader { geo in
            NavigationView {
            VStack {
                //Rectangle()
                    //.fill(Color.init(UIColor.systemBackground))
                    //.frame(minHeight: 1, idealHeight: 4, maxHeight: 4, alignment: .center)
                //TextField(NSLocalizedString("filter", comment: "main window search filter caption 2"), text: filterBind)
                    //.padding(2)
                    //.keyboardType(.default)
                ZStack {
                List {
                ForEach(docFiles2Filtered, id: \.fileUrl) {tfa in
                    NavigationLink(tag: tfa.fileUrl,
                                   selection: self.$listSelection,
                                   destination: {
                        MainTabViewer(tab: tfa.tab)
                    },
                                   label: {
                        Text( tfa.tab.title)
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
                } //fe
                } //ls
                //.listStyle(ListStyle.)
                .searchable( text: $searchFilter, placement: .navigationBarDrawer(displayMode: .always), prompt: "filter", suggestions: {
                //.searchable( text: $searchFilter, prompt: "filter") {
                    ForEach(Array( docFiles2Filtered.prefix(3)), id: \.fileUrl) {tfa in
                        Text(String.localizedStringWithFormat(NSLocalizedString("result: %@", comment: "search result suggestion"), tfa.tab.title))
                            .searchCompletion( tfa.tab.title)
                    } //fe in src
                }) //flt
                    if docFilesLoaded && docFiles.isEmpty {
                        VStack {
                            Text("You have no songs in the list.")
                            Button(NSLocalizedString("Tap here to add a song from the public domain, to get you started", comment: "")) {
                                    self.showingNewTabUrlPD = true
                            } //btn
                        } //vs
                        .frame(maxWidth: geo.size.width * 0.66, alignment: .center)
                    } //if
                } //zs
                HStack {
                    NavigationLink {
                        HowToUseMainView()
                    } label: {
                        Label(NSLocalizedString("How to use", comment: "how to use main screen button"), systemImage: "questionmark.diamond")
                    }
                    .padding(.horizontal)
                    Text("\(listSelection?.path.count ?? 0 )")
                        .hidden()
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
                    // .padding(.horizontal)
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
                    // .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .contentShape(Rectangle())
                    .accessibilityLabel(NSLocalizedString("Add text directly", comment: "main window add text button"))
                    .accessibility(hint: Text(NSLocalizedString("you can paste text directly", comment: "main window add text button hint")))
                } //hs
                .padding(.bottom)
            } //vs
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
            .onAppear(perform: {
                DispatchQueue.main.async {
                    listDocFiles()
                } //as
            }) //onapp
            .sheet(isPresented: $showingNewTabUrl, onDismiss: {
                listDocFiles()
            }, content: {
                NewTabUrlContent(initialAddress: "",
                                 autoFetchClipBoard: true,
                                    browseAutomatically: true,
                                 shouldCloseAfterSaving: .onlyIfDidSave
                )
        })
            .sheet(isPresented: $showingNewTabUrlPD, onDismiss: {
                listDocFiles()
            }, content: {
                NewTabUrlContent(initialAddress: self.newTabUrlPD,
                                 autoFetchClipBoard: false,
                                    browseAutomatically: true,
                                 shouldCloseAfterSaving: .onlyIfDidSave
                )
        })
            .sheet(isPresented: $showingNewTabFromText, onDismiss: {
                listDocFiles()
            }, content: {
                                    NewTabFromTextContent()
        }) //sheet
        } //body
    
    func deleteItem(tfa: TabFileAssoc) -> Bool {
        if let _ = try? FileManager.default.removeItem( at: tfa.fileUrl) {
            listDocFiles()
            return true
        }
        return false
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
            // self.filter(self.filterCount)
            if let selected = self.listSelection {
                if !docFiles.contains(where: {
                    $0.fileUrl == selected
                }) {
                    self.listSelection = nil
                }
            }
            self.docFilesLoaded = true
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
