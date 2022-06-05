//
//  Sidebar.swift
//  ClashUI
//
//  Created by Jiaxin Shou on 2022/6/5.
//

import SwiftUI

// TODO: Edit by user
let clients = [
    ClashClient(host: "127.0.0.1", port: 9090),
    ClashClient(host: "tower.local", port: 9090),
]

struct Sidebar: View {
    var body: some View {
        VStack {
            List(clients) { client in
                SidebarSection(client: client)
            }

            Spacer()

            HStack {
                Button {
                    // TODO: Add new backend
                } label: {
                    Label("New Backend", systemImage: "plus.circle")
                }
                .buttonStyle(.plain)
                .padding()
                .foregroundColor(.secondary)

                Spacer()
            }
        }
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Sidebar()
                .frame(width: 180)
        }
    }
}
