//
//  TelegramService.swift
//  RwTickets
//
//  Created by Kiryl Klimiankou on 11/29/19.
//  Copyright © 2019 Kiryl Klimiankou. All rights reserved.
//

import Foundation
import RxSwift

struct TelegramPrivateInfo {
    internal let apiToken = "703409987:AAGLD4IQ3bsRmckYWloy2SmnONDq1NVBj1A"
    internal let chatId = "@RwTickets"
}

enum TelegramError: Error {
    case badURL
}

protocol Telegram {
    var privateInfo: TelegramPrivateInfo! { get }
    func sendMessage(_ message: CustomStringConvertible) -> Observable<String>
}

class TelegramService: Telegram {
    var privateInfo: TelegramPrivateInfo!

    init(privateInfo: TelegramPrivateInfo = TelegramPrivateInfo()) {
        self.privateInfo = privateInfo
    }
    
    func sendMessage(_ message: CustomStringConvertible) -> Observable<String> {
        let message = message.description
        guard let url = buildURL(with: message) else { return .error(TelegramError.badURL) }
        let request = URLRequest(url: url)
        return URLSession.shared.rx.response(request: request)
            .map { _ in message }
            .take(1)
    }
    
    // MARK: - Private Methods
    private func buildURL(with message: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.telegram.org"
        components.path = "/bot\(privateInfo.apiToken)/sendMessage"
        components.queryItems = [
            URLQueryItem(name: "chat_id", value: privateInfo.chatId),
            URLQueryItem(name: "text", value: message)
        ]
        return components.url
    }
}
