//
//  VersionPopover.swift
//  ClashUI
//
//  Created by Jiaxin Shou on 2022/6/6.
//

import SwiftUI

struct VersionPopover: View {
    let isPremium: Bool

    let version: String

    var body: some View {
        VStack {
            if isPremium {
                Text("Premium")
                    .font(.custom("Copperplate", size: 10))
                    .fontWeight(.semibold)
                    .padding(4)
                    .background(RoundedRectangle(cornerRadius: 4).stroke(lineWidth: 1.5))
                    .shadow(color: .secondary, radius: 2, x: 0, y: 0)
            }

            Text("Version: \(version)")
                .font(.system(.callout, design: .monospaced))
        }
        .padding(8)
        .foregroundColor(.primary)
    }
}

struct VersionPopover_Previews: PreviewProvider {
    static var previews: some View {
        VersionPopover(isPremium: true, version: "2022.06.06")

        VersionPopover(isPremium: false, version: "2022.06.05")
    }
}
