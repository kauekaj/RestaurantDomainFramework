//
//  RemoteRestaurantLoader.swift
//  RestaurantDomain
//
//  Created by Kaue de Assis Jacyntho on 20/04/23.
//

import Foundation


final class NetworkClient {
    
    static let shared: NetworkClient = NetworkClient()
    private(set) var urlRequest: URL?
    init() {}
    
    func request(from url: URL) {
        urlRequest = url
    }
}


final class RemoteRestaurantLoader {
    
    let url: URL
    init(url: URL) {
        self.url = url
    }
    
    func load() {
        NetworkClient.shared.request(from: url)
    }
    
}
