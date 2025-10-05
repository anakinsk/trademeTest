// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI
import Styleguide

// MARK: - Views
// MARK: Main Screen

struct LatestListingsView: View {
    @State private var viewModel = LatestListingsViewModel()
    
    @State private var selectedListing: LatestListing?
    @State private var showRowAlert = false
    
    @State private var showToolbarAlert = false
    @State private var toolbarAlertMessage = ""
    
    var body: some View {
        NavigationView {
            Group {
                switch viewModel.screenData {
                case .loading:
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                    
                case .done(let result):
                    switch result {
                    case .success(let listings):
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 12) {
                                ForEach(listings, id: \.id) { listing in
                                    LatestListingRow(listing: listing)
                                        .padding(.horizontal)
                                        .onTapGesture {
                                            selectedListing = listing
                                            showRowAlert = true
                                        }
                                            
                                    Divider()
                                }
                            }
                        }
                    case .failure:
                        Text("Failed to load latest listings")
                            .foregroundColor(SemanticColors.textDark.color)
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        toolbarAlertMessage = "Search tapped"
                        showToolbarAlert = true
                    } label: {
                        Icons.search.image
                    }

                    Button {
                        toolbarAlertMessage = "Cart tapped"
                        showToolbarAlert = true
                    } label: {
                        Icons.cart.image
                    }
                }
            }
            .alert(toolbarAlertMessage, isPresented: $showToolbarAlert) {
                Button("OK", role: .cancel) {}
            }
            .alert("Listing tapped", isPresented: $showRowAlert, actions: {
                Button("OK", role: .cancel) { }
            }, message: {
                if let listing = selectedListing {
                    Text(listing.title)
                }
            })
            .navigationTitle("Latest Listings")
            .task {
                await viewModel.load()
            }
        }
    }
}

// MARK: Row

struct LatestListingRow: View {
    let listing: LatestListing
    let defaultImageName = "photo"
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: listing.imageUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure(_):
                    Image(systemName: defaultImageName)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(SemanticColors.imageTint.color)
                @unknown default:
                    Image(systemName: defaultImageName)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(SemanticColors.imageTint.color)
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(listing.location)
                    .font(.subheadline)
                    .foregroundColor(SemanticColors.textLight.color)
                
                Text(listing.title)
                    .font(.headline)
                    .foregroundColor(SemanticColors.textDark.color)
                    .lineLimit(2)

                priceView(for: listing)
            }
        }
        .padding(.vertical, 8)
    }
    
    @ViewBuilder
    private func priceView(for listing: LatestListing) -> some View {
        if let auction = listing as? LatestListingAuction {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(auction.currentPrice)
                            .font(.subheadline)
                            .foregroundColor(SemanticColors.textDark.color)
                        Text("Current price")
                            .font(.caption)
                            .foregroundColor(SemanticColors.textLight.color)
                    }

                    Spacer()

                    if let buyNow = auction.buyNowPrice {
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(buyNow)
                                .font(.subheadline)
                                .foregroundColor(SemanticColors.textDark.color)
                            Text("Buy Now")
                                .font(.caption)
                                .foregroundColor(SemanticColors.textLight.color)
                        }
                    }
                }
            } else if let classified = listing as? LatestListingClassified {
                VStack(alignment: .leading, spacing: 2) {
                    Text(classified.askingPrice)
                        .font(.subheadline)
                        .foregroundColor(SemanticColors.textDark.color)
                }
            } else {
                EmptyView()
            }
    }
}

// MARK: - Preview

#Preview {
    LatestListingsView()
}
