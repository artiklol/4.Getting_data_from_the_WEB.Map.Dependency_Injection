//
//  NetworkManager.swift
//  task_4
//
//  Created by Artem Sulzhenko on 30.12.2022.
//

import Foundation

class NetworkManager {

    static private let jsonUrlList = "https://belarusbank.by/api/atm"

    static func fetchData(completion: @escaping ([WelcomeElement]) -> Void) {
        guard let url = URL(string: jsonUrlList) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in

            if let error = error {
                print("test \(error.localizedDescription)")
                return
            }

            if let response = response {
                print("test123 \(response)")
            }
            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode(Welcome.self, from: data)
                let ATMs = result

                DispatchQueue.main.async {
                    completion(ATMs)
                }
            } catch let error {
                print(error)
            }

        }.resume()
    }

}
