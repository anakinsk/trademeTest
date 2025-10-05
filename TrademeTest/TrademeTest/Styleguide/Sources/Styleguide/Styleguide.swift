// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI

public enum RawColors: String {
    case tasman500 = "Tasman500"
    case feijoa500 = "Feijoa500"
    case bluffOyster800 = "BluffOyster800"
    case bluffOyster600 = "BluffOyster600"
    
    public var color: Color {
        Color(self.rawValue, bundle: .module)
    }
}

public enum SemanticColors {
    case textLight
    case textDark
    case imageTint
    
    public var color: Color {
        switch self {
        case .textDark:
            return RawColors.bluffOyster800.color
        case .textLight:
            return RawColors.bluffOyster600.color
        case .imageTint:
            return RawColors.bluffOyster600.color
        }
    }
}

public enum Icons: String {
    case cart
    case profile = "profile-16"
    case watchlist
    case search
    
    public var image: Image {
        Image(self.rawValue, bundle: .module)
    }
}
