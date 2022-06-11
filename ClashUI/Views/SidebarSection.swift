//
//  SidebarSection.swift
//  ClashUI
//
//  Created by Jiaxin Shou on 2022/6/5.
//

import SwiftUI

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

    @State private var isVersionPresented = false

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
            Task {
                try await backend.updateVersion()
            }
        }
    }

    private var header: some View {
        HStack {
            Text("\(backend.host ?? ""):\(String(backend.port))")
                .font(.system(size: 11, weight: .medium, design: .default))

            Button {
                isVersionPresented.toggle()
            } label: {
                Image(systemName: "info.circle")
            }
            .buttonStyle(.plain)
            .font(.system(size: 11))
            .popover(isPresented: $isVersionPresented) {
                VersionPopover(isPremium: backend.isPremium, version: backend.version ?? "")
            }
        }
        .foregroundColor(.secondary)
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
