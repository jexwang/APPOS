//
//  APIManager.swift
//  APPOS
//
//  Created by Jay on 2020/11/4.
//

import SwiftUI
import Combine

// MARK: - HTTPMethod
private enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case patch = "PATCH"
}

// MARK: - APIError
enum APIError: Error {
    case networkError
    case dataFormatError
    case backendError(message: String)
    case unknown(message: String)
    
    var localizedStringKey: LocalizedStringKey {
        switch self {
        case .networkError:
            return .networkError
        case .dataFormatError:
            return .dataFormatError
        case .backendError(let message):
            return LocalizedStringKey(message)
        case .unknown(let message):
            return LocalizedStringKey(message)
        }
    }
}

// MARK: - APIRequest
typealias APIRequest<T: Decodable> = AnyPublisher<T, APIError>

// MARK: - APIManager
class APIManager {
    
    static let shared: APIManager = APIManager()
    
    private let url: URL = URL(string: "http://35.233.166.164/api/v1/")!
    private let encoder: JSONEncoder = JSONEncoder()
    private let decoder: JSONDecoder = JSONDecoder()
    
    var token: String?
    
    private init() {}
    
}

// MARK: - Private functions
private extension APIManager {
    
    private func createDataTaskPublisher(url: URL, method: HTTPMethod, body: Data?) -> URLSession.DataTaskPublisher {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let token = token {
            request.addValue(token, forHTTPHeaderField: "app_token")
        }
        
        if let body = body {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
    }
    
    private func createRequestPublisher<T: Decodable>(path: String, method: HTTPMethod, queryItems: [URLQueryItem]? = nil, body: Data?) -> APIRequest<T> {
        var urlWithPath: URL = url.appendingPathComponent(path)
        
        if let queryItems = queryItems,
           var urlComponents = URLComponents(url: urlWithPath, resolvingAgainstBaseURL: true) {
            urlComponents.queryItems = queryItems
            urlWithPath = urlComponents.url ?? urlWithPath
        }
        
        return createDataTaskPublisher(url: urlWithPath, method: method, body: body)
            .tryMap { (output) -> Data in
                if self.checkHTTPStatusCodeIsSuccess(response: output.response) {
                    if output.data.count == 0 {
                        return "{}".data(using: .utf8)!
                    } else {
                        return output.data
                    }
                } else {
                    let parseResult: Result<ErrorData, APIError> = self.parseData(data: output.data)
                    switch parseResult {
                    case .success(let errorData):
                        throw APIError.backendError(message: errorData.message)
                    case .failure(let error):
                        throw error
                    }
                }
            }
            .decode(type: T.self, decoder: decoder)
            .mapError(toAPIError)
            .eraseToAnyPublisher()
    }
    
    private func checkHTTPStatusCodeIsSuccess(response: URLResponse?) -> Bool {
        guard let response = response as? HTTPURLResponse else { return false }
        return response.statusCode >= 200 && response.statusCode <= 299
    }
    
    private func parseData<T: Decodable>(data: Data) -> Result<T, APIError> {
        do {
            let parseResult = try decoder.decode(T.self, from: data)
            return .success(parseResult)
        } catch {
            return .failure(.dataFormatError)
        }
    }
    
    private func toAPIError(_ error: Error) -> APIError {
        switch error {
        case is Foundation.URLError:
            return .networkError
        case is Swift.DecodingError:
            return .dataFormatError
        case let apiError as APIError:
            return apiError
        default:
            return .unknown(message: error.localizedDescription)
        }
    }
    
}

// MARK: - Internal functions
extension APIManager {
    
    func login(mail: String, password: String) -> APIRequest<LoginResult> {
        let body = """
        {
            "mail": "\(mail)",
            "password": "\(password)"
        }
        """.data(using: .utf8)!
        return createRequestPublisher(path: "auth_user", method: .post, body: body)
    }
    
    func logout() -> APIRequest<Blank> {
        return createRequestPublisher(path: "auth", method: .delete, body: nil)
    }
    
    func getCompanies() -> APIRequest<PaginationResult<Company>> {
        createRequestPublisher(path: "companies", method: .get, body: nil)
    }
    
    func createCompany(companyData: CreateCompany) -> APIRequest<Blank> {
        Just(companyData)
            .encode(encoder: encoder)
            .mapError(toAPIError)
            .flatMap { self.createRequestPublisher(path: "companies", method: .post, body: $0) }
            .eraseToAnyPublisher()
    }

    func getCompany(by companyID: Int) -> APIRequest<Company> {
        createRequestPublisher(path: "companies/\(companyID)", method: .get, body: nil)
    }
    
    func updateCompany(id companyID: Int, companyData: UpdateCompany) -> APIRequest<Blank> {
        Just(companyData)
            .encode(encoder: encoder)
            .mapError(toAPIError)
            .flatMap { self.createRequestPublisher(path: "companies/\(companyID)", method: .patch, body: $0) }
            .eraseToAnyPublisher()
    }
    
}
