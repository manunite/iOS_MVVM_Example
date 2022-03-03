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
      guard let self = self else { return }
      let paramString: String = String.init(format: "현재 유저의 URL은 %@입니다.", info.current_user_url!)
      self.outputs.onReceiveData.accept(paramString)
    }
  }
}

extension ViewModel: ViewModelOutputs {
  
}

extension ViewModel: ModelListenerProtocol {
  func onRecevieData(receiveData: ReceiveData) {
    let paramString: String = String.init(format: "현재 유저의 URL은 %@입니다.", receiveData.current_user_url!)
    self.outputs.onReceiveData.accept(paramString)
  }
}
