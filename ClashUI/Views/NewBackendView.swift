//
//  NewBackendView.swift
//  ClashUI
//
//  Created by Jiaxin Shou on 2022/6/11.
//

import SwiftUI

private let portFormatter: NumberFormatter = {
    let f = NumberFormatter()
    f.minimum = 0
    f.maximum = 65535
    // Port 0 is reserved and cannot be used for TCP
    f.zeroSymbol = ""
    return f
}()

struct NewBackendView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var host: String = ""

    @State private var port: Int = 0

    @State private var secret: String = ""

    @FocusState private var isHostFocused: Bool

    @FocusState private var isPortFocused: Bool

    @State private var isHostErrorPresented: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Form {
                TextField("Host", text: $host, prompt: Text("Required"))
                    .focused($isHostFocused)
                    .popover(isPresented: $isHostErrorPresented, arrowEdge: .trailing) {
                        HStack {
                            Image(systemName: "xmark.diamond")
                                .foregroundColor(.red)
                                .font(.title)

                            Text("Host Error")
                        }
                        .padding(12)
                    }

                TextField("Port", value: $port, formatter: portFormatter, prompt: Text("Required"))
                    .focused($isPortFocused)

                SecureField("Secret", text: $secret, prompt: Text("Optional"))
                    // Set the content type to .password to avoid empty popover bug
                    // https://stackoverflow.com/questions/71127439/swiftui-strange-empty-popover-near-textfield
                    .textContentType(.password)
            }
            .textFieldStyle(.roundedBorder)
            .disableAutocorrection(true)

            HStack {
                Spacer()

                Button(action: addBackend) {
                    Text("Add")
                        .padding()
                }
                .keyboardShortcut(.return)
            }
        }
        .padding()
        .frame(width: 300)
    }

    private func addBackend() {
        guard !host.isEmpty else {
            isHostFocused = true
            return
        }

        guard validateHost() else {
            isHostFocused = true
            isHostErrorPresented = true
            return
        }

        guard port != 0 else {
            isPortFocused = true
            return
        }

        // TODO: De-duplication

        // TODO: Test connection

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

    private func validateHost() -> Bool {
        let range = NSMakeRange(0, host.count)
        let pattern = #"^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$|^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)+([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return false
        }
        return regex.numberOfMatches(in: host, range: range) > 0
    }
}

struct NewBackendView_Previews: PreviewProvider {
    static var previews: some View {
        NewBackendView()
    }
}
