import UIKit

enum ContactRemoteService {
    enum ContactRemoteError: Error {
        case invalidURL
        case decodingFailed
    }
    
    static func fetchRandom() async throws -> Contact {
        guard let url = URL(string: "https://randomuser.me/api/") else {
            throw ContactRemoteError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let decoded = try? JSONDecoder().decode(RandomUserResponse.self, from: data),
              let user = decoded.results.first else {
            throw ContactRemoteError.decodingFailed
        }
        
        return await toContactModel(user)
    }
    
    static func toContactModel(_ user: RandomUser) async -> Contact {
        let name = "\(user.name.first) \(user.name.last)"
        let phone = user.phone
        let imageFilename = await RemoteImageService.fetchImage(urlString: user.picture.large)
        
        return Contact(name: name, phone: phone, imageFilename: imageFilename)
    }
}
