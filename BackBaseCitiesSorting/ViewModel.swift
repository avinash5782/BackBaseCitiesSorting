//
//  ViewModel.swift
//  BackBaseCitiesSorting
//
//  Created by Avinash on 03/07/21.
//


import Foundation
import Combine
class ViewModel  {
    
    let passthroughobj = PassthroughSubject<CityDataModel, Error>()
    init() {
    }
    func fetdata() {
        if let path = Bundle.main.path(forResource: "cities", ofType: "json") {
            do {
                guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else { return  }
                let userCityData = try JSONDecoder().decode(CityDataModel.self, from: jsonData)
                self.passthroughobj.send( userCityData)
            } catch {
                self.passthroughobj.send(completion: .failure(error))
            }
        }
    }
    
}
//        ApiManager.shared.fetchUser(url: self.url) {[weak self]( result: Result<CityDataModel, Error>) in
//            switch result {
//            case .failure(let error):
//                self?.passthroughobj.send(completion: .failure(error))
//            case .success(let data):
//                self?.passthroughobj.send(data)
//            }
//        }
//    }
//}
//}
