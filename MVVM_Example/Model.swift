//
//  Model.swift
//  MVVM_Example
//
//  Created by heogj123 on 2022/03/03.
//

import Foundation
import Alamofire

public class ReceiveData: Codable {
  var current_user_url: String?
  var current_user_authorizations_html_url: String?
  var authorizations_url: String?
  var code_search_url: String?
}

protocol ModelListenerProtocol: AnyObject {
  func onRecevieData(receiveData: ReceiveData)
}

protocol ModelMethodProtocol {
  func requestData(completion: @escaping ((ReceiveData) -> Void))
}

class Model: NSObject {
  static let shared = Model()
  
  private override init() {
    super.init()
  }
  
  private weak var listener: ModelListenerProtocol?
}

extension Model: ModelMethodProtocol {
  func requestData(completion: @escaping ((ReceiveData) -> Void)) {
    // 클라이언트의 요청 및 서버의 응답이 오는 경우
    // ex.
    // [1] Client -> Server (Request to Server)
    // [2] Client <- Server (Response from Server)
    let requestPath: String = "https://api.github.com"
    AF.request(requestPath, method: .get).responseDecodable(of: ReceiveData.self) { (response) in
      switch response.result {
      case .success:
        guard let info = response.value else { break }
        completion(info)
      case .failure:
        break
      }
    }
  }
  
  func onReceiveRequestData(data: ReceiveData) {
    // 서버에서 클라이언트로 일방적 응답이 오는 경우.
    // 클라이언트와 서버가 Connect 상태이고, 서버의 사정으로 인해 끊어졌거나 등의 알림을 클라이언트로 알려주는 경우 등이 있음.
    // ex.
    // [1] Client <- Server (Response from Server)
    self.listener?.onRecevieData(receiveData: data)
  }
}
