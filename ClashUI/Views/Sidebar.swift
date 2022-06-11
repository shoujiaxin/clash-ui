//
//  Sidebar.swift
//  ClashUI
//
//  Created by Jiaxin Shou on 2022/6/5.
//

import SwiftUI

struct Sidebar: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.index)])
    private var backends: FetchedResults<Backend>

    var body: some View {
        VStack {
            if !backends.isEmpty {
                List(backends) { backend in
                    SidebarSection(backend: backend)
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
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
