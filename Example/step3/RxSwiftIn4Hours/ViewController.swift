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

  override func viewDidLoad() {
    super.viewDidLoad()
    bindUI()
  }

  // MARK: - IBOutlet

  @IBOutlet var idField: UITextField!
  @IBOutlet var pwField: UITextField!
  @IBOutlet var loginButton: UIButton!
  @IBOutlet var idValidView: UIView!
  @IBOutlet var pwValidView: UIView!

  // MARK: - Bind UI

  private func bindUI() {
    // id input +--> check valid --> bullet
    //          |
    //          +--> button enable
    //          |
    // pw input +--> check valid --> bullet

    // input: 아이디, 비번 입력
    let idInputOb: Observable<String> = idField.rx.text.orEmpty.asObservable()
    let idValidOb = idInputOb.map(checkEmailValid)

    let pwInputOb: Observable<String> = pwField.rx.text.orEmpty.asObservable()
    let pwValidOb = pwInputOb.map(checkPasswordValid)

    // output: 불릿, 로그인 버튼 enable
    idValidOb.subscribe(onNext: {
      self.idValidView.isHidden = $0
    }).disposed(by: disposeBag)

    pwValidOb.subscribe(onNext: {
      self.pwValidView.isHidden = $0
    }).disposed(by: disposeBag)

    Observable.combineLatest(idValidOb, pwValidOb, resultSelector: { $0 && $1 })
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
