//
//  ApiClient.swift
//  GitUsersDemo
//
//  Created by Nirav Patel on 22/11/22.
//

var usersList = "https://api.github.com/users"
var userDtails = "https://api.github.com/users/"

import Foundation
import Combine

enum NetworkError: Error{
    case decodeError
    case domainError
    case urlError
    case sessionError
}

enum HTTPMethod: String{
    case get = "GET"
    case post = "POST"
}

struct Resource<T: Codable> {
    let url: URL
    var httpMethod: HTTPMethod = .get
    var body: Data? = nil
}

extension Resource {
    init(url:URL){
        self.url = url
    }
}


class WebServiceManager {
    func fetch<T>(res:Resource<T>)->AnyPublisher<T,Error>{
        return URLSession.shared.dataTaskPublisher(for: res.url)
            .map {$0.data}
            .decode(type: T.self, decoder: JSONDecoder() )
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}


