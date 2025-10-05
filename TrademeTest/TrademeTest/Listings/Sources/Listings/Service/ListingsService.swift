import Foundation
import Networking

struct ListingResponseDTO: Decodable {
    let totalCount: Int
    let page: Int
    let pageSize: Int
    let list: [ListingDTO]
    
    enum CodingKeys: String, CodingKey {
            case totalCount = "TotalCount"
            case page = "Page"
            case pageSize = "PageSize"
            case list = "List"
        }
}

struct ListingDTO: Decodable {
    let region: String
    let title: String
    let pictureHref: String?
    let priceDisplay: String
    let buyNowPrice: Decimal?
    let isClassified: Bool?
    
    enum CodingKeys: String, CodingKey {
            case region = "Region"
            case title = "Title"
            case pictureHref = "PictureHref"
            case priceDisplay = "PriceDisplay"
            case buyNowPrice = "BuyNowPrice"
            case isClassified = "IsClassified"
        }
}

protocol ListingsServiceProtocol: Sendable {
    func fetchLatestListings() async throws -> [ListingDTO]
}

final class ListingsService: ListingsServiceProtocol {
    private let network: NetworkingInterface
    
    init(network: NetworkingInterface = Networking.shared) {
        self.network = network
    }
    
    @concurrent
    func fetchLatestListings() async throws -> [ListingDTO] {
        let url = "https://api.tmsandbox.co.nz/v1/listings/latest.json?rows=20"
        let result: ListingResponseDTO = try await network.get(url: url)
        return result.list
    }
}
