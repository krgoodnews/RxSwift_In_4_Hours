//
//  ViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {
  var disposeBag = DisposeBag()

  let idInputText = BehaviorSubject(value: "")
  let idValid = BehaviorSubject(value: false)

  let pwInputText = BehaviorSubject(value: "")
  let pwValid = BehaviorSubject(value: false)

  override func viewDidLoad() {
    super.viewDidLoad()
    bindInput()
    bindOutput()
  }

  // MARK: - IBOutlet

  @IBOutlet var idField: UITextField!
  @IBOutlet var pwField: UITextField!
  @IBOutlet var loginButton: UIButton!
  @IBOutlet var idValidView: UIView!
  @IBOutlet var pwValidView: UIView!

  // MARK: - Bind UI

  /// 들어오는 입력을 Subject에 저장한다.
  private func bindInput() {
    // input: 아이디, 비번 입력
    idField.rx.text.orEmpty
      .bind(to: idInputText)
      .disposed(by: disposeBag)

    idInputText
      .map(checkEmailValid)
      .bind(to: idValid)
      .disposed(by: disposeBag)

    pwField.rx.text.orEmpty
      .bind(to: pwInputText)
      .disposed(by: disposeBag)

    pwInputText
      .map(checkPasswordValid)
      .bind(to: pwValid)
      .disposed(by: disposeBag)
  }

  /// Subject의 value를 이용해 View의 아웃풋을 지정한다.
  private func bindOutput() {
    // output: 불릿, 로그인 버튼 enable
    idValid.subscribe(onNext: {
      self.idValidView.isHidden = $0
    }).disposed(by: disposeBag)

    pwValid.subscribe(onNext: {
      self.pwValidView.isHidden = $0
    }).disposed(by: disposeBag)

    Observable.combineLatest(idValid, pwValid, resultSelector: { $0 && $1 })
      .subscribe(onNext: { self.loginButton.isEnabled = $0})
      .disposed(by: disposeBag)




//    idField.rx.text.orEmpty
//      .map(checkEmailValid)
//      .subscribe(onNext: { b in
//        self.idValidView.isHidden = b
//      }).disposed(by: disposeBag)
//
//    pwField.rx.text.orEmpty
//      .map(checkPasswordValid)
//      .subscribe(onNext: { b in
//        self.pwValidView.isHidden = b
//      }).disposed(by: disposeBag)
//
//    Observable.combineLatest(
//      idField.rx.text.orEmpty.map(checkEmailValid),
//      pwField.rx.text.orEmpty.map(checkPasswordValid),
//      resultSelector: { $0 && $1 })
//      .subscribe(onNext: { isCompleteInput in
//        self.loginButton.isEnabled = isCompleteInput
//      }).disposed(by: disposeBag)

  }

  // MARK: - Logic

  private func checkEmailValid(_ email: String) -> Bool {
    return email.contains("@")
  }

  private func checkPasswordValid(_ password: String) -> Bool {
    return password.count > 5
  }
}
