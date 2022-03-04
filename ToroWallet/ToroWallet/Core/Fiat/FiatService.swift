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

    private var toggleAvailableRelay = BehaviorRelay<Bool>(value: false)

    var currency: Currency {
        currencyKit.baseCurrency
    }

    var coinAmountLocked = false

    init(switchService: AmountTypeSwitchService, currencyKit: CurrencyKit.Kit, marketKit: MarketKit.Kit) {
        self.switchService = switchService
        self.currencyKit = currencyKit
        self.marketKit = marketKit

        subscribe(disposeBag, switchService.amountTypeObservable) { [weak self] in self?.sync(amountType: $0) }

        sync()
    }

    private func sync(coinPrice: CoinPrice?) {
        if let coinPrice = coinPrice, !coinPrice.expired {
            price = coinPrice.value

            if coinAmountLocked {
                syncCurrencyAmount()
            } else {
                syncCurrencyAmount()
                syncCoinAmount()
            }
        } else {
            price = nil
        }

        sync()
    }

    private func sync(amountType: AmountTypeSwitchService.AmountType) {
        sync()
    }
