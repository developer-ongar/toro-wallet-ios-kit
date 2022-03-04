import EthereumKit
import BigInt
import RxSwift
import RxRelay

protocol IEvmTransactionFeeService {
    var customFeeRange: ClosedRange<Int> { get }

    var hasEstimatedFee: Bool { get }
    var transactionStatus: DataStatus<EvmTransactionService.Transaction> { get }
    var transactionStatusObservable: Observable<DataStatus<EvmTransactionService.Transaction>> { get }

    var gasPriceType: EvmTransactionService.GasPriceType { get }
    var gasPriceTypeObservable: Observable<EvmTransactionService.GasPriceType> { get }

    var warningOfStuckObservable: Observable<Bool> { get }

    func set(gasPriceType: EvmTransactionService.GasPriceType)
}

class EvmTransactionService {
    private let evmKit: Kit
    private let feeRateProvider: ICustomRangedFeeRateProvider
    let gasLimitSurchargePercent: Int

    private var transactionData: TransactionData?

    private let gasPriceTypeRelay = PublishRelay<GasPriceType>()
    private(set) var gasPriceType: GasPriceType = .recommended {
        didSet {
            gasPriceTypeRelay.accept(gasPriceType)
        }
    }

    private var recommendedGasPrice: Int?
    private let warningOfStuckRelay = PublishRelay<Bool>()

    private let transactionStatusRelay = PublishRelay<DataStatus<Transaction>>()
    private(set) var transactionStatus: DataStatus<Transaction> = .failed(GasDataError.noTransactionData) {
        didSet {
            transactionStatusRelay.accept(transactionStatus)
        }
    }

    private var disposeBag = DisposeBag()

    init(evmKit: Kit, feeRateProvider: ICustomRangedFeeRateProvider, gasLimitSurchargePercent: Int = 0, customFeeRange: ClosedRange<Int> = 1...400) {
        self.evmKit = evmKit
        self.feeRateProvider = feeRateProvider
        self.gasLimitSurchargePercent = gasLimitSurchargePercent
    }

    private func gasPriceSingle(gasPriceType: GasPriceType) -> Single<Int> {
        var recommendedSingle: Single<Int> = feeRateProvider.feeRate(priority: .recommended)

        switch gasPriceType {
        case .recommended:
            warningOfStuckRelay.accept(false)
            return recommendedSingle
        case .custom(let gasPrice):
            if let recommendedGasPrice = recommendedGasPrice {
                recommendedSingle = .just(recommendedGasPrice)
            }

            return recommendedSingle.map { [weak self] recommendedGasPrice in
                self?.warningOfStuckRelay.accept(gasPrice < recommendedGasPrice)
                return gasPrice
            }
        }
    }
