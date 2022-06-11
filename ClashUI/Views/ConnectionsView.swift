//
//  ConnectionsView.swift
//  ClashUI
//
//  Created by Jiaxin Shou on 2022/6/11.
//

import SwiftUI

struct ConnectionsView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .toolbar {
                Button {
                    // TODO: Close all connections
                } label: {
                    Image(systemName: "xmark.circle")
                }
            }
    }
}

struct ConnectionsView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionsView()
            .frame(width: 600, height: 400)
    }
}
