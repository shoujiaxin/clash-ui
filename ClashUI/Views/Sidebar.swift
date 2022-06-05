//
//  Sidebar.swift
//  ClashUI
//
//  Created by Jiaxin Shou on 2022/6/5.
//

import SwiftUI

struct Sidebar: View {
    @State private var selection: String? = "Overview"

    var body: some View {
        VStack {
            // TODO: Multi backends
            List {
                Section {
                    NavigationLink(tag: "Overview", selection: $selection) {
                        Text("Overview")
                            .navigationTitle("Overview")
                    } label: {
                        Label("Overview", systemImage: "chart.xyaxis.line")
                    }

                    NavigationLink(tag: "Proxies", selection: $selection) {
                        Text("Proxies")
                            .navigationTitle("Proxies")
                    } label: {
                        Label("Proxies", systemImage: "network")
                    }

                    NavigationLink(tag: "Rules", selection: $selection) {
                        Text("Rules")
                            .navigationTitle("Rules")
                    } label: {
                        Label("Rules", systemImage: "ruler")
                    }

                    NavigationLink(tag: "Connections", selection: $selection) {
                        Text("Connections")
                            .navigationTitle("Connections")
                    } label: {
                        Label("Connections", systemImage: "app.connected.to.app.below.fill")
                    }

                    NavigationLink(tag: "Settings", selection: $selection) {
                        Text("Settings")
                            .navigationTitle("Settings")
                    } label: {
                        Label("Settings", systemImage: "gearshape")
                    }

                    NavigationLink(tag: "Logs", selection: $selection) {
                        Text("Logs")
                            .navigationTitle("Logs")
                    } label: {
                        Label("Logs", systemImage: "doc.text")
                    }
                } header: {
                    HStack {
                        Text("backend")

                        Button {
                            // TODO: Get version
                        } label: {
                            Image(systemName: "info.circle")
                        }
                        .buttonStyle(.plain)
                    }
                }
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
