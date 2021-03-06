//
//  SidebarSection.swift
//  ClashUI
//
//  Created by Jiaxin Shou on 2022/6/5.
//

import SwiftUI

private let headerFontSize: CGFloat = 11

// TODO: Add view
private let tabs = [
    (name: "Overview", iconName: "chart.xyaxis.line"),
    (name: "Proxies", iconName: "network"),
    (name: "Rules", iconName: "ruler"),
    (name: "Connections", iconName: "app.connected.to.app.below.fill"),
    (name: "Settings", iconName: "gearshape"),
    (name: "Logs", iconName: "doc.text"),
]

struct SidebarSection: View {
    let backend: Backend

    @Binding var selection: String?

    @Environment(\.managedObjectContext) private var viewContext

    @State private var isVersionPresented: Bool = false

    @State private var connectionFailed: Bool = false

    @State private var connectionFailedAlertPresented: Bool = false

    @State private var connectionFailedMessage: String = ""

    var body: some View {
        // If use Section here, app will crash when deleting the last item
        DisclosureGroup(isExpanded: .constant(true)) {
            ForEach(tabs, id: \.name) { tab in
                NavigationLink(tag: "\(backend.id)-\(tab.name)", selection: $selection) {
                    Text(tab.name)
                        .navigationTitle(tab.name)
                } label: {
                    Label(tab.name, systemImage: tab.iconName)
                }
            }
            // Disable the ability to move tab items
            .onMove(perform: nil)
        } label: {
            header
        }
        .onAppear {
            Task { await updateBackendInfo() }
        }
    }

    private var header: some View {
        HStack {
            Text("\(backend.host ?? ""):\(String(backend.port))")
                .font(.system(size: headerFontSize, weight: .medium, design: .default))

            Button {
                isVersionPresented.toggle()
            } label: {
                Image(systemName: "info.circle")
            }
            .buttonStyle(.plain)
            .font(.system(size: headerFontSize))
            .popover(isPresented: $isVersionPresented) {
                VersionPopover(isPremium: backend.isPremium, version: backend.version ?? "")
            }

            Spacer()

            if connectionFailed {
                Image(systemName: "bolt.horizontal.circle")
                    .font(.system(size: headerFontSize))
            }
        }
        .foregroundColor(.secondary)
        .contentShape(Rectangle())
        .contextMenu {
            Button {
                Task {
                    await updateBackendInfo()
                    connectionFailedAlertPresented = connectionFailed
                }
            } label: {
                Text("Connect")
            }
            .disabled(!connectionFailed)

            Divider()

            Button {
                if selection?.starts(with: "\(backend.id)") == true {
                    selection = nil
                }
                // Add this animation to make the changes to selection take effect
                withAnimation(.easeInOut) {
                    viewContext.delete(backend)
                    try? viewContext.save()
                }
            } label: {
                Text("Remove")
            }
            .keyboardShortcut("d", modifiers: .command)
        }
        .alert("Connection Failed", isPresented: $connectionFailedAlertPresented) {
            Button("OK") {}
        } message: {
            Text(connectionFailedMessage)
        }
    }

    private func updateBackendInfo() async {
        do {
            try await backend.getInfo()
            connectionFailed = false
        } catch {
            connectionFailed = true
            connectionFailedMessage = error.localizedDescription
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
                    SidebarSection(backend: backend!, selection: .constant(nil))
                }
            }
            .frame(width: 180)
        }
    }
}
