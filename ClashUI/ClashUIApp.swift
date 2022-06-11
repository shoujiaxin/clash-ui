//
//  ClashUIApp.swift
//  ClashUI
//
//  Created by Jiaxin Shou on 2022/6/5.
//

import SwiftUI

@main
struct ClashUIApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
        .commands {
            SidebarCommands()
        }
    }
}
