//
//  RxCocoa+Extra.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIButton {
    var oneTap: Observable<Void> {
        return tap.throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.asyncInstance)
    }
}

extension Reactive where Base: UIBarButtonItem {
    var oneTap: Observable<Void> {
        return tap.throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.asyncInstance)
    }
}

extension ObservableType {

    func withPrevious(startWith first: Element) -> Observable<(Element, Element)> {
        return scan((first, first)) { ($0.1, $1) }.skip(1)
    }

    func observeOnMain() -> Observable<Element> {
        return observeOn(MainScheduler.instance)
    }
}
