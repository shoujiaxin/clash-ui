//
//  Backend.swift
//  ClashUI
//
//  Created by Jiaxin Shou on 2022/6/11.
//

import Foundation

extension Backend {
    var url: URL? {
        guard let host = host else {
            return nil
        }
        return URL(string: "http://\(host):\(port)")
    }

    func updateVersion() async throws {
        guard let url = url?.appendingPathComponent("version") else {
            return
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200 ..< 300 ~= statusCode else {
            return
        }

        let info = try JSONDecoder().decode(Version.self, from: data)
        isPremium = info.premium
        version = info.version
    }
}

// MARK: - Version

private struct Version: Codable {
    let premium: Bool

    let version: String
}
