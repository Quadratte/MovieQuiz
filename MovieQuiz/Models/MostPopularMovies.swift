import Foundation

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovies]
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRaiting"
        case imageURL = "image"
    }
}
