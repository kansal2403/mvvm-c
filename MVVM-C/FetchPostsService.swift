//
//  FetchPostsService.swift
//  MVVM-C
//
//  Created by Rahish Kansal on 26/04/24.
//

import Foundation

enum RestError: Error {
    case badUrl
    case requestFailed
}

struct PageInfo {
    let start: Int
    let size: Int
}

protocol FetchPostsService {
    func fetchPosts(pageInfo: PageInfo,
                    completion: @escaping (Result<[Post], Error>)->Void)
}

class FetchPostsServiceImpl: FetchPostsService {
    func fetchPosts(pageInfo: PageInfo,
                    completion: @escaping (Result<[Post], Error>)->Void) {
        guard let url = URL.init(string: "https://jsonplaceholder.typicode.com/posts?_start=\(pageInfo.start)&_limit=\(pageInfo.size)") else {
            completion(.failure(RestError.badUrl))
            return
        }
        
        URLSession.shared.dataTask(with:  URLRequest.init(url: url)) { data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode == 200, let data {
                let jsonDecoder = JSONDecoder()
                do {
                    let posts = try jsonDecoder.decode([Post].self, from: data)
                    completion(.success(posts))
                } catch {
                    completion(.failure(error))
                }
            } else {
                if let error {
                    completion(.failure(error))
                } else {
                    completion(.failure(RestError.requestFailed))
                }
            }
        }
        .resume()
    }
}
