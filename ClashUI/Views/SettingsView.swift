//
//  SettingsView.swift
//  ClashUI
//
//  Created by Jiaxin Shou on 2022/6/11.
//

import SwiftUI

struct SettingsView: View {
    @State private var mode: String = "Rule"

    @State private var logLevel: String = "Warning"

    var body: some View {
        VStack {
            GroupBox {
                Form {
                    Picker("Mode", selection: $mode) {
                        Text("Rule").tag("Rule")
                        Text("Global").tag("Global")
                        Text("Direct").tag("Direct")
                    }
                    .pickerStyle(.segmented)

                    Picker("Log Level", selection: $logLevel) {
                        Text("Info").tag("Info")
                        Text("Warning").tag("Warning")
                        Text("Error").tag("Error")
                        Text("Debug").tag("Debug")
                        Text("Silent").tag("Silent")
                    }
                    .pickerStyle(.segmented)
                }
                .padding()
            }

            GroupBox {}
        }
        .padding()
        .frame(width: 400)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
