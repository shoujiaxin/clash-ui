//
//  Backend.swift
//  ClashUI
//
//  Created by Jiaxin Shou on 2022/6/11.
//

import CoreData
import Foundation

class Backend: NSManagedObject {
    @Published private(set) var status: ConnectionStatus = .disconnected

    private var url: URL? {
        guard let host = host else {
            return nil
        }
        return URL(string: "http://\(host):\(port)")
    }

    @discardableResult
    func getInfo() async throws -> Info {
        guard let url = url?.appendingPathComponent("version") else {
            throw Self.Error.url
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw Self.Error.noResponse
        }
        guard 200 ..< 300 ~= httpResponse.statusCode else {
            throw Self.Error.badRequest(message: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
        }

        let info = try JSONDecoder().decode(Info.self, from: data)
        isPremium = info.isPremium
        version = info.version

        return info
    }
}

extension Backend {
    enum ConnectionStatus {
        case connected
        case disconnected
        case unavailable(Error)
    }

    enum Error: Swift.Error {
        case url
        case badRequest(message: String)
        case noResponse
    }

    struct Info: Codable {
        let isPremium: Bool

        let version: String

        private enum CodingKeys: String, CodingKey {
            case isPremium = "premium"
            case version
        }
    }
}
