//
//  QuoteService.swift
//  PetesQuotes
//
//  Created by Peter Ent on 11/18/20.
//

import Foundation
import Alamofire

/**
 * Struct used to store a quote from the QuoteService. A collection of these are cached privately
 * by the QuoteService and delivered when requested.
 */
struct Quote: Decodable {
    let author: String?
    let text: String?
}

/**
 * The QuoteService uses a remote call to fetch a set of quotations and caches them. Further requests
 * return immediately if the cache is available.
 */
class QuoteService: NSObject, ObservableObject {
    
    typealias CompletionHandler = (Quote?) -> Void
        
    private var cache = [Quote]()
    private var isBusy = false
    
    func randomQuote() -> Quote? {
        if let quote = cache.randomElement() {
            return quote
        }
        return nil
    }
    
    func getQuote(completion: @escaping ()->Void) {
        if !cache.isEmpty {
            completion()
        }
        
        guard !isBusy else { return }
        isBusy = true
        
        AF.request("https://type.fit/api/quotes").responseJSON { response in
            if let data = response.data {
                do {
                    let values = try JSONDecoder().decode([Quote].self, from: data)
                    self.cache.removeAll()
                    self.cache.append(contentsOf: values)
                    DispatchQueue.main.async {
                        completion()
                    }
                } catch {
                    print("Failed to decode: \(error)")
                    completion()
                }
            }
            if let error = response.error {
                debugPrint(error)
                completion()
            }
            self.isBusy = false // can now fetch data again if cache is cleared
        }
    }
}
