//
//  ViewController.swift
//  MVVM_Example
//
//  Created by heogj123 on 2022/03/03.
//

import UIKit
import RxSwift
import SnapKit
import Then

class ViewController: UIViewController {

  // RX
  let disposeBag = DisposeBag()
  
  // ViewModel
  let viewModel = ViewModel()
  
  // UI Components
  let resultLabel = UILabel().then {
    $0.text = "결과 표시 Label"
    $0.textAlignment = .center
    $0.numberOfLines = 2
  }
  let requestButton = UIButton().then {
    $0.setTitle("업데이트 Button", for: .normal)
    $0.setTitleColor(.brown, for: .normal)
    $0.layer.borderColor = UIColor.brown.cgColor
    $0.layer.borderWidth = 1.0
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // UI구성
    self.setComponentAndConstraints()
    
    // View - ViewModel 바인딩
    self.bindViewModel()
    
    // 버튼클릭을 통한 ViewModel에 값 업데이트 요청 동작
    self.requestButton.rx.tap.subscribe(onNext: {[weak self] in
      guard let self = self else { return }
      self.viewModel.inputs.requestData()
    }).disposed(by: disposeBag)
  }
  
  private func setComponentAndConstraints() {
    self.view.addSubview(resultLabel)
    self.view.addSubview(requestButton)
    
    self.resultLabel.snp.makeConstraints { make in
      make.width.equalTo(self.view.safeAreaLayoutGuide)
      make.centerX.equalTo(self.view.safeAreaLayoutGuide)
      make.centerY.equalTo(self.view.safeAreaLayoutGuide).offset(-25)
    }
    self.requestButton.snp.makeConstraints { make in
      make.width.equalTo(150)
      make.centerX.equalTo(self.view.safeAreaLayoutGuide)
      make.top.equalTo(self.resultLabel.snp.bottom).offset(20)
    }
  }
  
  func bindViewModel() {
    self.viewModel.outputs.onReceiveData.asSignal().emit(onNext: {[weak self] data in
      guard let self = self else { return }
      // ViewModel로부터 값 업데이트
      self.resultLabel.text = data
    }).disposed(by: disposeBag)
  }
}

