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

    @FocusState private var isHostTextFieldFocused: Bool

    @FocusState private var isPortTextFieldFocused: Bool

    @State private var isHostErrorPopoverPresented: Bool = false

    @State private var isBackendAlreadyExistsPopoverPresented: Bool = false

    @State private var connectionFailedAlertPresented: Bool = false

    @State private var connectionFailedMessage: String = ""

    @State private var isAddingNewBackend: Bool = false

    var body: some View {
        VStack {
            Form {
                TextField("Host", text: $host, prompt: Text("Required"))
                    .focused($isHostTextFieldFocused)
                    .popover(isPresented: $isHostErrorPopoverPresented, arrowEdge: .trailing) {
                        Label {
                            Text("Host Error")
                        } icon: {
                            Image(systemName: "xmark.diamond.fill")
                                .foregroundColor(.red)
                        }
                        .padding(10)
                    }

                TextField("Port", value: $port, formatter: portFormatter, prompt: Text("Required"))
                    .focused($isPortTextFieldFocused)

                SecureField("Secret", text: $secret, prompt: Text("Optional"))
                    // Set the content type to .password to avoid empty popover bug
                    // https://stackoverflow.com/questions/71127439/swiftui-strange-empty-popover-near-textfield
                    .textContentType(.password)
            }
            .textFieldStyle(.roundedBorder)
            .disableAutocorrection(true)

            HStack {
                Spacer()

                if isAddingNewBackend {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(0.5)
                }

                Button {
                    Task {
                        isAddingNewBackend = true
                        await addBackend()
                        isAddingNewBackend = false
                    }
                } label: {
                    Text("Add")
                        .padding()
                }
                .padding(.vertical, 10)
                .keyboardShortcut(.return)
                .disabled(isAddingNewBackend)
                .popover(isPresented: $isBackendAlreadyExistsPopoverPresented, arrowEdge: .bottom) {
                    Label {
                        Text("Backend Already Exists")
                    } icon: {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.yellow)
                    }
                    .padding(10)
                }
            }
        }
        .padding()
        .frame(width: 300)
        .alert("Connection Failed", isPresented: $connectionFailedAlertPresented) {
            Button("OK") {}
        } message: {
            Text(connectionFailedMessage)
        }
    }

    private func addBackend() async {
        guard !host.isEmpty else {
            isHostTextFieldFocused = true
            return
        }

        guard validateHost() else {
            isHostTextFieldFocused = true
            isHostErrorPopoverPresented = true
            return
        }

        guard port != 0 else {
            isPortTextFieldFocused = true
            return
        }

        // De-duplication
        let request = Backend.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "%K == %@", NSExpression(forKeyPath: \Backend.host).keyPath, host),
            NSPredicate(format: "%K == %d", NSExpression(forKeyPath: \Backend.port).keyPath, port),
        ])
        guard let count = try? viewContext.count(for: request), count == 0 else {
            isHostTextFieldFocused = true
            isBackendAlreadyExistsPopoverPresented = true
            return
        }

        // Create an instance, but do NOT insert into the database
        let backend = Backend(entity: .entity(forEntityName: "Backend", in: viewContext)!, insertInto: nil)
        backend.index = Int64((try? viewContext.count(for: Backend.fetchRequest())) ?? 0)
        backend.host = host
        backend.port = Int32(port)

        // Test connectivity
        await backend.testConnectivity()
        switch backend.status {
        case .connected:
            // Insert into the database
            viewContext.insert(backend)
            try? viewContext.save()
        case .disconnected:
            return
        case let .unavailable(error):
            connectionFailedAlertPresented = true
            connectionFailedMessage = error.localizedDescription
        }
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
