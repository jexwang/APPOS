//
//  APIManager.swift
//  APPOS
//
//  Created by 王冠綸 on 2020/11/4.
//

import Foundation

private enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

enum APIError: Error {
    case networkError
    case dataFormatError
    case noResponseData
    case backendError(message: String)
}

extension APIError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .networkError:
            return "網路異常"
        case .dataFormatError:
            return "資料格式異常"
        case .noResponseData:
            return "無回應資料"
        case .backendError(let message):
            return message
        }
    }
}

class APIManager {
    
    static let url: URL = URL(string: "http://35.233.166.164/api/v1/")!
    static private(set) var token: String?
    static private let encoder: JSONEncoder = JSONEncoder()
    static private let decoder: JSONDecoder = JSONDecoder()
    
}

// MARK: - Private functions
private extension APIManager {
    
    private static func sendRequest(url: URL, method: HTTPMethod, body: Data?, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let token = token {
            request.addValue(token, forHTTPHeaderField: "app_token")
        }
        
        if method == .post {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }
        
        URLSession.shared.dataTask(with: request, completionHandler: completion).resume()
    }
    
    private static func standardRequest<T: Decodable>(path: String, method: HTTPMethod, queryItems: [URLQueryItem]? = nil, body: Data?, completion: @escaping (Result<T, APIError>) -> Void) {
        var urlWithPath: URL = url.appendingPathComponent(path)
        
        if let queryItems = queryItems,
           var urlComponents = URLComponents(url: urlWithPath, resolvingAgainstBaseURL: true) {
            urlComponents.queryItems = queryItems
            urlWithPath = urlComponents.url ?? urlWithPath
        }
        
        sendRequest(url: urlWithPath, method: method, body: body) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    if checkHTTPStatusCodeIsSuccess(response: response) {
                        if data.count == 0 {
                            // 防止部分成功不回傳資料的狀況
                            let data = "{}".data(using: .utf8)!
                            completion(parseData(data: data))
                        } else {
                            completion(parseData(data: data))
                        }
                    } else {
                        let parseResult: Result<ErrorData, APIError> = parseData(data: data)
                        switch parseResult {
                        case .success(let errorData):
                            completion(.failure(.backendError(message: errorData.message)))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(.networkError))
                }
            }
        }
    }
    
    private static func checkHTTPStatusCodeIsSuccess(response: URLResponse?) -> Bool {
        guard let response = response as? HTTPURLResponse else { return false }
        return response.statusCode >= 200 && response.statusCode <= 299
    }
    
    private static func parseData<T: Decodable>(data: Data) -> Result<T, APIError> {
        do {
            let parseResult = try decoder.decode(T.self, from: data)
            return .success(parseResult)
        } catch {
            return .failure(.dataFormatError)
        }
    }
    
}

// MARK: - Internal functions
extension APIManager {
    
    static func setToken(_ token: String) {
        self.token = token
    }
    
    static func clearToken() {
        self.token = nil
    }
    
    static func login(mail: String, password: String, completion: @escaping (Result<LoginResult, APIError>) -> Void) {
        let body = """
        {
            "mail": "\(mail)",
            "password": "\(password)"
        }
        """.data(using: .utf8)!
        standardRequest(path: "auth_user", method: .post, body: body, completion: completion)
    }
    
    static func getCompanies(completion: @escaping (Result<PaginationResult<Company>, APIError>) -> Void) {
        standardRequest(path: "companies", method: .get, body: nil, completion: completion)
    }
    
    static func createCompany(company: CreateCompany, completion: @escaping (Result<Blank, APIError>) -> Void) {
        do {
            let companyData = try encoder.encode(company)
            standardRequest(path: "companies", method: .post, body: companyData, completion: completion)
        } catch {
            completion(.failure(.dataFormatError))
        }
    }
    
    static func searchCompany(id: Int, completion: @escaping (Result<Company, APIError>) -> Void) {
        standardRequest(path: "companies/\(id)", method: .get, body: nil, completion: completion)
    }
    
}
