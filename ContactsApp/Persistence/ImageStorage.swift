import UIKit

enum ImageStorageError: Error {
    case failedToConvertImage
    case fileNotFound
}

final class ImageStorage {
    static let shared = ImageStorage()
    
    private init() {}
    
    func saveImage(_ image: UIImage) throws -> String {
        let filename = UUID().uuidString
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        
        guard let data = image.pngData() else {
            throw ImageStorageError.failedToConvertImage
        }
        
        try data.write(to: url)
        return filename
    }
    
    func loadImage(filename: String) -> UIImage? {
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        return UIImage(contentsOfFile: url.path)
    }
    
    func deleteImage(filename: String) throws {
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw ImageStorageError.fileNotFound
        }
        try FileManager.default.removeItem(at: url)
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
