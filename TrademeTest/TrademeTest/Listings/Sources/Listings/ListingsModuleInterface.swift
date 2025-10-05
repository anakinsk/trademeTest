import Foundation
import SwiftUI

public protocol ListingsModuleInterface {
    func listingsView() -> AnyView
}

@MainActor
public final class ListingsModule: @MainActor ListingsModuleInterface {
    public static let shared = ListingsModule()
    
    public func listingsView() -> AnyView {
        AnyView(LatestListingsView())
    }
}
