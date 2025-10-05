import Foundation

protocol ListingsRepositoryProtocol: Sendable {
    func fetchLatestListings() async throws -> [LatestListing]
}

final class ListingsRepository: ListingsRepositoryProtocol {
    private let service: ListingsServiceProtocol
    
    init(service: ListingsServiceProtocol = ListingsService()) {
        self.service = service
    }
    
    @concurrent
    func fetchLatestListings() async throws -> [LatestListing] {
        let dtos = try await service.fetchLatestListings()
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return dtos.map { dto in
            if dto.isClassified == true {
                return LatestListingClassified(
                    location: dto.region,
                    title: dto.title,
                    imageUrl: dto.pictureHref ?? "wrongURL://",
                    askingPrice: dto.priceDisplay
                )
            } else {
                return LatestListingAuction(
                    location: dto.region,
                    title: dto.title,
                    imageUrl: dto.pictureHref ?? "wrongURL://",
                    currentPrice: dto.priceDisplay,
                    buyNowPrice: formatter.string(from: NSDecimalNumber(decimal: dto.buyNowPrice ?? 0))
                )
            }
        }
    }
}
