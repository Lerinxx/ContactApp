import UIKit

enum RemoteImageService {
    static func fetchImage(urlString: String) async -> String? {
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            return try? ImageStorage.shared.saveImage(image)
        } catch {
            return nil
        }
    }
}
