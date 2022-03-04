import RxSwift
import RxRelay
import StorageKit

class AmountTypeSwitchService {
    private let amountTypeKey = "amount-type-switch-service-amount-type"
    private let localStorage: StorageKit.ILocalStorage

    private var toggleAvailableObservables = [Observable<Bool>]()
    private var disposeBag = DisposeBag()

    private let amountTypeRelay = PublishRelay<AmountType>()
    private(set) var amountType: AmountType {
        didSet {
            amountTypeRelay.accept(amountType)
        }
    }

    private var toggleAvailableRelay = PublishRelay<Bool>()
    private(set) var toggleAvailable: Bool = false {
        didSet {
            if toggleAvailable != oldValue {
                toggleAvailableRelay.accept(toggleAvailable)
            }
        }
    }
