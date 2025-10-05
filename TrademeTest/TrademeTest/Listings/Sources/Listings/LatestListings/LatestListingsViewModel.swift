import Foundation

protocol LatestListing: Sendable {
    var id: UUID { get }
    var location: String { get }
    var title: String { get }
    var imageUrl: String { get }
}

struct LatestListingAuction: LatestListing {
    let id: UUID = UUID()
    let location: String
    let title: String
    let imageUrl: String
    let currentPrice: String
    let buyNowPrice: String?
}

struct LatestListingClassified: LatestListing {
    let id: UUID = UUID()
    let location: String
    let title: String
    let imageUrl: String
    let askingPrice: String
}

enum LatestListingError: Error {
    case error1
    case error2
}

typealias LatestListingResult = Result<[LatestListing], LatestListingError>

enum ScreenData: Sendable {
    case loading
    case done(result: LatestListingResult)
}

@Observable @MainActor
final class LatestListingsViewModel {
    var screenData: ScreenData = .loading
    
    private let repository: ListingsRepositoryProtocol
    
    init(repository: ListingsRepositoryProtocol = ListingsRepository()) {
            self.repository = repository
    }
        
    func load() async {
        screenData = .loading
                    
        do {
            let listings = try await repository.fetchLatestListings()
            screenData = .done(result: .success(listings))
        } catch {
            screenData = .done(result: .failure(.error2))
        }
    }
}
