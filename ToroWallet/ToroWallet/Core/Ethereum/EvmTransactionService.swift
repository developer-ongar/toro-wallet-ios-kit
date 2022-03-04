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
