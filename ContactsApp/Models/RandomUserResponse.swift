import Foundation

struct RandomUserResponse: Decodable {
    let results: [RandomUser]
}

struct RandomUser: Decodable {
    let name: RandomUserName
    let phone: String
    let picture: RandomUserPicture
}

struct RandomUserName: Decodable {
    let first: String
    let last: String
}

struct RandomUserPicture: Decodable {
    let large: String
}
