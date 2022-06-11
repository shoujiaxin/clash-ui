//
//  ContentView.swift
//  ClashUI
//
//  Created by Jiaxin Shou on 2022/6/5.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            Sidebar()
                .frame(minWidth: 160)
                .toolbar {
                    Button(action: toggleSidebar) {
                        Image(systemName: "sidebar.left")
                    }
                }

            NewBackendView()
        }
    }

    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
