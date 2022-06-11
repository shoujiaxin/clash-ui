//
//  SidebarSection.swift
//  ClashUI
//
//  Created by Jiaxin Shou on 2022/6/5.
//

import SwiftUI

struct SidebarSection: View {
    let backend: Backend

    @Environment(\.managedObjectContext) private var viewContext

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
                Text("\(backend.host ?? ""):\(backend.port)")

                Button {
                    isVersionPresented.toggle()
                } label: {
                    Image(systemName: "info.circle")
                }
                .buttonStyle(.plain)
                .popover(isPresented: $isVersionPresented) {
                    VersionPopover(isPremium: backend.isPremium, version: backend.version ?? "")
                }

                Spacer()
            }
            .contentShape(Rectangle())
            .contextMenu {
                Button {
                    viewContext.delete(backend)
                    try? viewContext.save()
                } label: {
                    Text("Remove")
                }
                .keyboardShortcut("d", modifiers: .command)
            }
        }
        .onAppear {
            Task {
                try await backend.updateVersion()
            }
        }
    }
}

struct SidebarSection_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let request = Backend.fetchRequest()
        request.fetchLimit = 1
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Backend.index, ascending: true),
        ]
        let backend = try? viewContext.fetch(request).first

        return NavigationView {
            VStack {
                List {
                    SidebarSection(backend: backend!)
                }
            }
            .frame(width: 180)
        }
    }
}
