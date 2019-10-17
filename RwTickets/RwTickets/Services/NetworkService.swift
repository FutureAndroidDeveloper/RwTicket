//
//  NetworkService.swift
//  RwTickets
//
//  Created by Kiryl Klimiankou on 10/14/19.
//  Copyright © 2019 Kiryl Klimiankou. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class NetworkService {
    enum SchemeType: String {
        case http = "http"
        case https = "https"
    }
    
    private let scheme: String!
    private let host: String!
    private let path: String!
    
    private let apiToken = "703409987:AAGLD4IQ3bsRmckYWloy2SmnONDq1NVBj1A"
    private let chatId = "@RwTickets"
    
    init(scheme: SchemeType = SchemeType.https, host: String = "rasp.rw.by", path: String = "/ru/route") {
        self.scheme = scheme.rawValue
        self.host = host
        self.path = path
    }
    
    func getHtmlTrains(from departureCity: String, to arrivalCity: String, at date: String) -> Observable<String> {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = [
            URLQueryItem(name: "from", value: departureCity),
            URLQueryItem(name: "from_exp", value: "0"),
            URLQueryItem(name: "from_esr", value: "0"),
            URLQueryItem(name: "to", value: arrivalCity),
            URLQueryItem(name: "to_exp", value: "0"),
            URLQueryItem(name: "to_esr", value: "0"),
            URLQueryItem(name: "date", value: date)
        ]
        
        return scrapePage(with: components.url!)
    }
    
    private func scrapePage(with url: URL) -> Observable<String> {
        let request = URLRequest(url: url)
        return URLSession.shared.rx
            .data(request: request)
            .compactMap { String(data: $0, encoding: .utf8) }
            .take(1)
    }
    
    func sendMessage(_ train: Train) -> Observable<String> {
        let places = train.places.map { $0.description }.joined(separator: "\n")
        let message = "\(train.departurDate ?? "")\n\(train.departureCity) -> \(train.arrivalCity)\n\(train.departureTime) -> \(train.arrivalTime) \(train.arrivalDate ?? "")\n\n\(places)"
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.telegram.org"
        components.path = "/bot\(apiToken)/sendMessage"
        components.queryItems = [
            URLQueryItem(name: "chat_id", value: chatId),
            URLQueryItem(name: "text", value: message)
        ]
        
        guard let url = components.url else { return .empty() }
        let request = URLRequest(url: url)
        return URLSession.shared.rx.response(request: request)
            .map { _ in places }
            .take(1)
    }
}
