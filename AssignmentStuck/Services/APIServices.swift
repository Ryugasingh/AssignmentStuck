//
//  APIServices.swift
//  AssignmentStuck
//
//  Created by Sambhav Singh on 06/03/25.
//

import Foundation

class APIService {
    static let shared = APIService()
    
    private init() { }
    
    func getProducts() async throws -> [Product] {
        let endPoint = "https://app.getswipe.in/api/public/get"
        guard let url = URL(string: endPoint) else {
            throw AError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw AError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Product].self, from: data)
        } catch {
            throw AError.invalidData
        }
    }
    
    func addProduct(_ product: Product, imageData: Data?) async throws -> Bool {
        guard let url = URL(string: "https://app.getswipe.in/api/public/add") else {
            throw AError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: String] = [
            "product_name": product.productName,
            "product_type": product.productType,
            "price": String(product.price),
            "tax": String(product.tax)
        ]
        
        let formData = createMultipartBody(parameters: parameters,
                                           fileData: imageData,
                                           fileName: imageData != nil ? "photo.jpg" : nil,
                                           boundary: boundary)
        request.httpBody = formData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let responseBody = String(data: data, encoding: .utf8) ?? "No response body"
            print("Status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
            print("Response body: \(responseBody)")
            throw AError.invalidResponse
        }
        
        return true
    }
}

