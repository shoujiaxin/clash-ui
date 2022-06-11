//
//  NewBackendView.swift
//  ClashUI
//
//  Created by Jiaxin Shou on 2022/6/11.
//

import SwiftUI

private let defaultHost = "127.0.0.1"

private let defaultPort = "9090"

struct NewBackendView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var host: String = ""

    @State private var port: String = ""

    @State private var secret: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Form {
                TextField(text: $host, prompt: Text(defaultHost)) {
                    Text("Host")
                }

                TextField(text: $port, prompt: Text(defaultPort)) {
                    Text("Port")
                }

                SecureField(text: $secret, prompt: Text("Optional")) {
                    Text("Secret")
                }
            }
            .textFieldStyle(.roundedBorder)

            HStack {
                Spacer()

                Button(action: addBackend) {
                    Text("Add")
                        .padding()
                }
            }
        }
        .padding()
        .frame(width: 300)
    }

    private func addBackend() {
        // TODO: De-duplication
        guard Backend(context: viewContext,
                      index: try? viewContext.count(for: Backend.fetchRequest()),
                      host: host,
                      port: Int(port)) != nil
        else {
            // TODO: Handle error
            return
        }

        try? viewContext.save()
    }
}

struct NewBackendView_Previews: PreviewProvider {
    static var previews: some View {
        NewBackendView()
    }
}
