//
//  Sidebar.swift
//  ClashUI
//
//  Created by Jiaxin Shou on 2022/6/5.
//

import SwiftUI

struct Sidebar: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [SortDescriptor(\.index)])
    private var backends: FetchedResults<Backend>

    @State private var selection: String? = nil

    var body: some View {
        VStack {
            List {
                ForEach(backends) { backend in
                    SidebarSection(backend: backend, selection: $selection)
                }
                .onMove { source, destination in
                    source.first.map { index in
                        backends[index].index = Int64(destination)
                        try? viewContext.save()
                    }
                }
            }

            Spacer()

            HStack {
                Button {
                    selection = nil
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
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
