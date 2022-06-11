//
//  Backend.swift
//  ClashUI
//
//  Created by Jiaxin Shou on 2022/6/11.
//

import CoreData
import Foundation

extension Backend {
    convenience init?(context: NSManagedObjectContext, index: Int?, host: String?, port: Int?) {
        guard let index = index, let host = host, let port = port else {
            return nil
        }

        // Validate host
        let range = NSMakeRange(0, host.count)
        let ipPattern = #"^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"#
        let hostnamePattern = #"^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$"#
        guard let ipRegex = try? NSRegularExpression(pattern: ipPattern),
              let hostnameRegex = try? NSRegularExpression(pattern: hostnamePattern)
        else {
            return nil
        }
        if ipRegex.numberOfMatches(in: host, range: range) == 0, hostnameRegex.numberOfMatches(in: host, range: range) == 0 {
            return nil
        }

        // Validate port
        guard port >= 0, port <= 65535 else {
            return nil
        }

        self.init(context: context)
        self.index = Int64(index)
        self.host = host
        self.port = Int32(port)
    }

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
