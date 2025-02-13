//
//  ViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxSwift
import UIKit

class ViewController: UITableViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

  func output(_ s: Any) {
    print(s)
  }

    @IBAction func exJust1() {
//        Observable.just("Hello World")
//            .subscribe(onNext: { str in
//                print(str)
//            })
//            .disposed(by: disposeBag)

//      Observable.from(["RxSwift", "In", "4", "Hours"])
//        .single()
//        .subscribe { (event) in
//          switch event {
//          case .next(let str):
//            print("next:", str)
//            break
//          case .error(let err):
//            print("err:", err)
//            break
//          case .completed:
//            print("completed")
//            break
//
//          }
//      }.disposed(by: disposeBag)
      Observable.from(["RxSwift", "In", "4", "Hours"])
        .subscribe(onNext: output,
                   onError: { err in
                    print("err:", err)
        }, onCompleted: {
          print("completed")
        }) {
          print("disposed")
      }.disposed(by: disposeBag)

    }

    @IBAction func exJust2() {
        Observable.just(["Hello", "World"])
            .subscribe(onNext: { arr in
                print(arr)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exFrom1() {
        Observable.from(["RxSwift", "In", "4", "Hours"])
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exMap1() {
        Observable.just("Hello")
            .map { str in "\(str) RxSwift" }
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exMap2() {
        Observable.from(["with", "곰튀김"])
            .map { $0.count }
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exFilter() {
        Observable.from([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
            .filter { $0 % 2 == 0 }
            .subscribe(onNext: { n in
                print(n)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exMap3() {
      Observable.just("800x600")
        .map { $0.replacingOccurrences(of: "x", with: "/") }
        .map { "https://picsum.photos/\($0)/?random" }
        .map { URL(string: $0) }
        .filter { $0 != nil }
        .map { $0! }
        .map { try Data(contentsOf: $0) }
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
        .map { UIImage(data: $0) }
        .observeOn(MainScheduler.instance)
        .do(onNext: { image in
          print(image?.size)
        })
        .subscribe(onNext: { image in
          self.imageView.image = image
        })
        .disposed(by: disposeBag)
    }
}
