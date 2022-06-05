//
//  ClashClient.swift
//  ClashUI
//
//  Created by Jiaxin Shou on 2022/6/5.
//

import SwiftUI

class ClashClient: ObservableObject {
    let url: URL

    @Published private(set) var isPremium = false

    @Published private(set) var version = ""

    // TODO: URLSession for tests
    init(host: String, port: Int) {
        // TODO: Handle error
        url = URL(string: "http://\(host):\(port)")!

        Task {
            try await getVersion()
        }
    }

    @MainActor
    func getVersion() async throws {
        let (data, response) = try await URLSession.shared.data(from: url.appendingPathComponent("version"))
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200 ..< 300 ~= statusCode else {
            return
        }

        let info = try JSONDecoder().decode(Version.self, from: data)
        isPremium = info.premium
        version = info.version
    }
}

extension ClashClient: Identifiable {
    var id: URL {
        return url
    }
}

private extension ClashClient {
    struct Version: Codable {
        let premium: Bool

        let version: String
    }
}
