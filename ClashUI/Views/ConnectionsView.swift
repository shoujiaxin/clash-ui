//
//  ConnectionsView.swift
//  ClashUI
//
//  Created by Jiaxin Shou on 2022/6/11.
//

import SwiftUI

struct ConnectionsView: View {
    var body: some View {
        List {
            Section {} header: {
                header
            }
        }
        .toolbar {
            Button {
                // TODO: Close all connections
            } label: {
                Image(systemName: "xmark.circle")
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
