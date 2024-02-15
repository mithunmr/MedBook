//
//  NetworkManager.swift
//  AssignmentMuseWearables
//
//  Created by MRM on 06/12/23.
//
import Foundation
import Network
enum fetchError:Error{
    case badUrl
    case decodingError
    case noData
}

class NetworkManager{
    let apiHandler:ApiHandler
    let responseHandler:ResponnseHandler
  
    init(apiHandler: ApiHandler = ApiHandler(), responseHandler: ResponnseHandler = ResponnseHandler() ) {
        self.apiHandler = apiHandler
        self.responseHandler = responseHandler
    }
    
    func fetchRequest<T:Codable>(type:T.Type, url:URL ,complition:@escaping(Result<T,fetchError>)->Void) {
        
            let request = URLRequest(url: url,cachePolicy: .returnCacheDataElseLoad)
    
            apiHandler.fetchData(request: request){ result in
                switch result {
                case .success(let data):
                    self.responseHandler.fetchModel(type:type , data: data){  result in
                        switch result {
                        case .success(let decodedData):
                            complition(.success(decodedData))
                        case .failure(let error):
                            complition(.failure(error))
                        }
                    }
                case .failure(let error):
                    complition(.failure(error))
                }
            }
    }
}

class ApiHandler{
    func fetchData(request:URLRequest ,complition: @escaping(Result<Data,fetchError>)->Void){
        URLSession.shared.dataTask(with: request){ data,response,error in
            guard let data = data,error == nil else {
                return complition(.failure(.badUrl))
                
            }
            complition(.success(data))
        }.resume()
    }
}
class ResponnseHandler {
    func fetchModel<T:Codable>(type:T.Type,data:Data, complition:@escaping(Result<T,fetchError>) ->Void){
        do {
            let decoder = JSONDecoder()
        
            let jsonData = try decoder.decode(type.self, from: data)
            complition(.success(jsonData))
        }catch{
            complition(.failure(.decodingError))
        }
    }
}



extension NWInterface.InterfaceType: CaseIterable {
    public static var allCases: [NWInterface.InterfaceType] = [
        .other,
        .wifi,
        .cellular,
        .loopback,
        .wiredEthernet
    ]
}

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let queue = DispatchQueue(label: "NetworkConnectivityMonitor")
    private let monitor: NWPathMonitor

    private(set) var isConnected = false
    private(set) var isExpensive = false
    private(set) var currentConnectionType: NWInterface.InterfaceType?

    private init() {
        monitor = NWPathMonitor()
    }

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status != .unsatisfied
            self?.isExpensive = path.isExpensive
            self?.currentConnectionType = NWInterface.InterfaceType.allCases.filter { path.usesInterfaceType($0) }.first
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
