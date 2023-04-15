//
//  urlRequest.swift
//  mealtime
//
//  Created by 문성호 on 2022/08/21.
//

import Foundation
import Alamofire

func get() {
    AF.request("https://geupsik-server.moonsung-ho.repl.co/geupsik?schoolCode=7031158&officeCode=B10&date=20220823").responseJSON() { response in
      switch response.result {
      case .success:
        if let data = try! response.result.get() as? [String: Any] {
          print(data)
        }
      case .failure(let error):
        print("Error: \(error)")
        return
      }
    }
}

get()
