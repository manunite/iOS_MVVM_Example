//
//  Model.swift
//  MVVM_Example
//
//  Created by heogj123 on 2022/03/03.
//

import Foundation
import Alamofire

public class ReceiveData: Codable {
  var client_ip: String?
  var datetime: String?
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
    // 클라이언트의 요청 및 서버의 응답이 오는 경우.
    // ex.
    // [1] Client -> Server (Request to Server)
    // [2] Client <- Server (Response from Server)
    let requestPath: String = "https://worldtimeapi.org/api/timezone/Asia/Seoul"
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
    // 클라이언트와 서버가 상시 연결중인 상태에서 서버의 사정으로 인해 끊어졌거나 서버의 상태가 변경되는 등의 상태 변화를 클라이언트로 알려주는 경우가 여기 동작에 해당.
    // ex.
    // [1] Client <- Server (Response from Server)
    self.listener?.onRecevieData(receiveData: data)
  }
}
