import Foundation

final class NetworkingClient: NetworkingInterface {
    let oauthConsumerKey: String = ""
    let oauthSignature: String = ""
    let oauthSignatureMethod: String = "PLAINTEXT"
    
    init() {}
    
    @concurrent
    func get<T: Decodable>(url: String) async throws -> T {
        guard let url = URL(string: url) else {
            throw NetworkingError.invalidURL
        }
        
        var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.setValue("OAuth", forHTTPHeaderField: "Authorization")
        let signature = "\(oauthSignature)&".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        request.setValue("OAuth oauth_consumer_key=\"\(oauthConsumerKey)\", oauth_signature_method=\"\(oauthSignatureMethod)\", oauth_signature=\"\(signature)\"", forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NetworkingError.requestFailed
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkingError.decodingFailed
        }
    }
}
