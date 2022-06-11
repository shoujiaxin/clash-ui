//
//  ConnectionsView.swift
//  ClashUI
//
//  Created by Jiaxin Shou on 2022/6/11.
//

import SwiftUI

struct ConnectionsView: View {
    @EnvironmentObject private var backend: Backend

    @State private var connections: [Backend.Connection] = []

    var body: some View {
        Table(connections) {
            TableColumn("Host", value: \.metadata.host)
            TableColumn("Network", value: \.metadata.network)
        }
        .toolbar {
            Button {
                // TODO: Close all connections
            } label: {
                Image(systemName: "xmark.circle")
            }
        }
        .onAppear {
            Task {
                connections = try await backend.getConnections()
            }
        }
    }

    private var header: some View {
        HStack(spacing: 20) {
            Text("Host")

            Text("Chains")

            Text("Rule")

            Text("Speed")

            Text("Upload")

            Text("Download")

            Text("Type")

            Text("Source")

            Text("Destination")

            Text("Time")
        }
        .font(.footnote)
        .foregroundColor(.secondary)
    }
}

struct ConnectionsView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionsView()
            .frame(width: 600, height: 400)
    }
}
