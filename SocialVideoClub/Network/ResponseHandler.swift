//
//  ResponseHandler.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 17/04/24.
//

import Foundation

struct ResponseHandler {
    func decode<T: Decodable>(type: T.Type, data: Data) -> Result<T, Error> {
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(T.self, from: data)
            return .success(decoded)
        } catch(let error) {
            return .failure(error)
        }
    }
}
