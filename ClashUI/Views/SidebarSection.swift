//
//  SidebarSection.swift
//  ClashUI
//
//  Created by Jiaxin Shou on 2022/6/5.
//

import SwiftUI

struct SidebarSection: View {
    let client: ClashClient

    @State private var isVersionPresented = false

    var body: some View {
        Section {
            NavigationLink {
                Text("Overview")
                    .navigationTitle("Overview")
            } label: {
                Label("Overview", systemImage: "chart.xyaxis.line")
            }

            NavigationLink {
                Text("Proxies")
                    .navigationTitle("Proxies")
            } label: {
                Label("Proxies", systemImage: "network")
            }

            NavigationLink {
                Text("Rules")
                    .navigationTitle("Rules")
            } label: {
                Label("Rules", systemImage: "ruler")
            }

            NavigationLink {
                Text("Connections")
                    .navigationTitle("Connections")
            } label: {
                Label("Connections", systemImage: "app.connected.to.app.below.fill")
            }

            NavigationLink {
                Text("Settings")
                    .navigationTitle("Settings")
            } label: {
                Label("Settings", systemImage: "gearshape")
            }

            NavigationLink {
                Text("Logs")
                    .navigationTitle("Logs")
            } label: {
                Label("Logs", systemImage: "doc.text")
            }
        } header: {
            HStack {
                Text(client.url.host ?? "")

                Button {
                    isVersionPresented.toggle()
                } label: {
                    Image(systemName: "info.circle")
                }
                .buttonStyle(.plain)
                .popover(isPresented: $isVersionPresented) {
                    VersionPopover(isPremium: client.isPremium, version: client.version)
                }
            }
        }
    }
}

struct SidebarSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VStack {
                List {
                    SidebarSection(client: ClashClient(host: "127.0.0.1", port: 9090))
                }
            }
            .frame(width: 180)
        }
    }
}
