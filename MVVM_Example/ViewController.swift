//
//  ViewController.swift
//  MVVM_Example
//
//  Created by heogj123 on 2022/03/03.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

  let disposeBag = DisposeBag()
  let viewModel = ViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.bindViewModel()
    viewModel.requestData()
  }
  
  func bindViewModel() {
    self.viewModel.outputs.onReceiveData.asSignal().emit(onNext: {[weak self] data in
      NSLog("\(data)")
    }).disposed(by: disposeBag)
  }


}

