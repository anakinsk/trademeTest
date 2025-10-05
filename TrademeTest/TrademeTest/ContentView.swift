import SwiftUI
import Listings
import Styleguide

struct ContentView: View {
        private let listingsModule: ListingsModuleInterface = ListingsModule.shared
        
        @State private var selectedTab: Int = 0
        
        var body: some View {
            TabView(selection: $selectedTab) {
                listingsModule.listingsView()
                    .tabItem {
                        Label {
                            Text("Latest listings")
                        } icon: {
                            Icons.search.image
                        }
                    }
                    .tag(0)
                
                Text("Watchlist")
                    .tabItem {
                        Label {
                            Text("Watchlist")
                        } icon: {
                            Icons.watchlist.image
                        }
                    }
                    .tag(1)
                
                Text("My Trade Me")
                    .tabItem {
                        Label {
                            Text("My Trade Me")
                        } icon: {
                            Icons.profile.image
                        }
                    }
                    .tag(2)
            }
        }
}

#Preview {
    ContentView()
}
