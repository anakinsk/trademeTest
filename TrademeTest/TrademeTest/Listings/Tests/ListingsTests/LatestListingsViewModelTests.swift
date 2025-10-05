import XCTest
@testable import Listings

@MainActor
final class LatestListingsViewModelTests: XCTestCase {
    func testLoadSuccess() async {
            // Arrange
            let mockRepo = MockListingsRepository()
            let expectedListing = LatestListingAuction(
                location: "Auckland",
                title: "Laptop",
                imageUrl: "https://example.com",
                currentPrice: "$1.00",
                buyNowPrice: "$5.00"
            )
            mockRepo.result = .success([expectedListing])
            let viewModel = LatestListingsViewModel(repository: mockRepo)
            
            // Act
            await viewModel.load()
            
            // Assert
            if case let .done(result) = viewModel.screenData {
                switch result {
                case .success(let listings):
                    XCTAssertEqual(listings.count, 1)
                    XCTAssertEqual(listings.first?.title, "Laptop")
                case .failure:
                    XCTFail("Expected success but got failure")
                }
            } else {
                XCTFail("Expected .done state")
            }
        }
        
        func testLoadFailure() async {
            // Arrange
            let mockRepo = MockListingsRepository()
            mockRepo.result = .failure(NSError(domain: "Test", code: 1))
            let viewModel = LatestListingsViewModel(repository: mockRepo)
            
            // Act
            await viewModel.load()
            
            // Assert
            if case let .done(result) = viewModel.screenData {
                switch result {
                case .success:
                    XCTFail("Expected failure but got success")
                case .failure(let error):
                    XCTAssertEqual(error, .error2)
                }
            } else {
                XCTFail("Expected .done state")
            }
        }
}

final class MockListingsRepository: ListingsRepositoryProtocol, @unchecked Sendable {
    var result: Result<[LatestListing], Error> = .success([])
    
    func fetchLatestListings() async throws -> [LatestListing] {
        switch result {
        case .success(let listings): return listings
        case .failure(let error): throw error
        }
    }
}
