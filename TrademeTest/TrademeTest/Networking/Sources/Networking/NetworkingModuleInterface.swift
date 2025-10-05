// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public enum NetworkingError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
}

public protocol NetworkingInterface: Sendable {
    func get<T: Decodable>(url: String) async throws -> T
}


public final class Networking: NetworkingInterface, Sendable {
    public static let shared = Networking()
    
    public init() {}
    
    public func get<T>(url: String) async throws -> T where T : Decodable {
        try await NetworkingClient().get(url: url)
    }
}
