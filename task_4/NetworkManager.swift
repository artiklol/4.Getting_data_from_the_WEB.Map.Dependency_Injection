//
//  NetworkManager.swift
//  task_4
//
//  Created by Artem Sulzhenko on 30.12.2022.
//

import Foundation

class NetworkManager {

    static private let jsonUrlList = "https://belarusbank.by/api/atm"

    static var statusCode: Int = 0

    static func fetchData(completion: @escaping ([WelcomeElement]) -> Void) {
        guard let url = URL(string: jsonUrlList) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let response = response as? HTTPURLResponse {
                statusCode = response.statusCode
            }

            guard let data = data else { return }
            guard let result = try? JSONDecoder().decode(Welcome.self, from: data) else { return }
            let ATMs = result

            DispatchQueue.main.async {
                completion(ATMs)
            }
        }.resume()
    }

}
