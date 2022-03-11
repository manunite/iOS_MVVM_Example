//
//  ViewModel.swift
//  MVVM_Example
//
//  Created by heogj123 on 2022/03/03.
//

import Foundation
import RxCocoa

public protocol ViewModelInputs {
  func requestData()
}

public protocol ViewModelOutputs {
  var onReceiveData: PublishRelay<String> { get }
}

public protocol ViewModelType {
  var inputs: ViewModelInputs { get }
  var outputs: ViewModelOutputs { get }
}

public final class ViewModel: ViewModelType {
  public var inputs: ViewModelInputs { return self }
  public var outputs: ViewModelOutputs { return self }
  
  public let onReceiveData = PublishRelay<String>()
  
  private let dataModel = Model.shared
  
  public init() {
    
  }
}

extension ViewModel: ViewModelInputs {
  public func requestData() {
    dataModel.requestData { [weak self] info in
      // ViewModel은 Model로부터 전달받은 info를 View에서 사용할수있도록 적절히 가공.
      guard let self = self, let clientIP = info.client_ip else { return }
      let paramString: String = String.init(format: "현재 유저의 IP는\n %@입니다.", clientIP)
      self.outputs.onReceiveData.accept(paramString)
    }
  }
}

extension ViewModel: ViewModelOutputs {
  
}

extension ViewModel: ModelListenerProtocol {
  func onRecevieData(receiveData: ReceiveData) {
    // ViewModel은 Model로부터 전달받은 info를 View에서 사용할수있도록 적절히 가공.
    guard let clientIP = receiveData.client_ip else { return }
    let paramString: String = String.init(format: "현재 유저의 IP는\n %@입니다.", clientIP)
    self.outputs.onReceiveData.accept(paramString)
  }
}
