import RxSwift
import RxCocoa

func subscribe<T>(_ disposeBag: DisposeBag, _ driver: Driver<T>, _ onNext: ((T) -> Void)? = nil) {
    driver.drive(onNext: onNext).disposed(by: disposeBag)
}

func subscribe<T>(_ disposeBag: DisposeBag, _ signal: Signal<T>, _ onNext: ((T) -> Void)? = nil) {
    signal.emit(onNext: onNext).disposed(by: disposeBag)
}

func subscribe<T>(_ disposeBag: DisposeBag, _ observable: Observable<T>, _ onNext: ((T) -> Void)? = nil) {
    observable
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .subscribe(onNext: onNext)
            .disposed(by: disposeBag)
}
