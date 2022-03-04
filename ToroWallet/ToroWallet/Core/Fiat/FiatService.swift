import CurrencyKit
import RxSwift
import RxRelay
import MarketKit

class FiatService {
    private var disposeBag = DisposeBag()
    private var coinPriceDisposeBag = DisposeBag()
    private var queue = DispatchQueue(label: "io.horizontalsystems.unstoppable.fiat-service", qos: .userInitiated)

    private let switchService: AmountTypeSwitchService
    private let currencyKit: CurrencyKit.Kit
    private let marketKit: MarketKit.Kit

    private var platformCoin: PlatformCoin?
    private var price: Decimal? {
        didSet {
            toggleAvailableRelay.accept(price != nil)
        }
    }

    private let coinAmountRelay = PublishRelay<Decimal>()
    private(set) var coinAmount: Decimal = 0

    private var currencyAmount: Decimal?

    private let primaryInfoRelay = PublishRelay<PrimaryInfo>()
    private(set) var primaryInfo: PrimaryInfo = .amount(amount: 0) {
        didSet {
            primaryInfoRelay.accept(primaryInfo)
        }
    }

    private let secondaryAmountInfoRelay = PublishRelay<AmountInfo?>()
    private(set) var secondaryAmountInfo: AmountInfo? {
        didSet {
            secondaryAmountInfoRelay.accept(secondaryAmountInfo)
        }
    }
