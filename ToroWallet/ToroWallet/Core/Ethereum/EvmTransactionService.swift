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
