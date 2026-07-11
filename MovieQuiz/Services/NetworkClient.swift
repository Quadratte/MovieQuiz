import Foundation

protocol NetworkRoutingProtocol {
    func fetch(url: URL, handler: @escaping (Result<Data,Error>) -> Void)
}

struct NetworkClient: NetworkRoutingProtocol {

    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data,Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                handler(.failure(error))
                return
            }
        
            guard
                let response = response as? HTTPURLResponse,
                200..<300 ~= response.statusCode
            else {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            guard let data else { return }
            handler(.success(data))
        }
        task.resume()
    }
}
