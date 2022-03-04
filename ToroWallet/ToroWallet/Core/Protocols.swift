import Foundation
import RxSwift
import GRDB
import UniswapKit
import EthereumKit
import ThemeKit
import Alamofire
import HsToolKit
import MarketKit
import BigInt

typealias CoinCode = String

protocol IRandomManager {
    func getRandomIndexes(max: Int, count: Int) -> [Int]
}

protocol ILocalStorage: AnyObject {
    var agreementAccepted: Bool { get set }
    var debugLog: String? { get set }
    var sendInputType: SendInputType? { get set }
    var mainShownOnce: Bool { get set }
    var jailbreakShownOnce: Bool { get set }
    var transactionDataSortMode: TransactionDataSortMode? { get set }
    var lockTimeEnabled: Bool { get set }
    var appLaunchCount: Int { get set }
    var rateAppLastRequestDate: Date? { get set }
    var zcashAlwaysPendingRewind: Bool { get set }

    func defaultProvider(blockchain: SwapModule.Dex.Blockchain) -> SwapModule.Dex.Provider
    func setDefaultProvider(blockchain: SwapModule.Dex.Blockchain, provider: SwapModule.Dex.Provider)
}

protocol ILogRecordManager {
    func logsGroupedBy(context: String) -> [(String, Any)]
    func onBecomeActive()
}

protocol ILogRecordStorage {
    func logs(context: String) -> [LogRecord]
    func save(logRecord: LogRecord)
    func logsCount() -> Int
    func removeFirstLogs(count: Int)
}

protocol IBaseAdapter {
    var isMainNet: Bool { get }
}

protocol IAdapter: AnyObject {
    func start()
    func stop()
    func refresh()

    var statusInfo: [(String, Any)] { get }
    var debugInfo: String { get }
}

protocol IBalanceAdapter: IBaseAdapter {
    var balanceState: AdapterState { get }
    var balanceStateUpdatedObservable: Observable<AdapterState> { get }
    var balanceData: BalanceData { get }
    var balanceDataUpdatedObservable: Observable<BalanceData> { get }
}

protocol IDepositAdapter: IBaseAdapter {
    var receiveAddress: String { get }
}

protocol ITransactionsAdapter {
    var transactionState: AdapterState { get }
    var transactionStateUpdatedObservable: Observable<Void> { get }
    var lastBlockInfo: LastBlockInfo? { get }
    var lastBlockUpdatedObservable: Observable<Void> { get }
    var explorerTitle: String { get }
    func explorerUrl(transactionHash: String) -> String?
    func transactionsObservable(coin: PlatformCoin?, filter: TransactionTypeFilter) -> Observable<[TransactionRecord]>
    func transactionsSingle(from: TransactionRecord?, coin: PlatformCoin?, filter: TransactionTypeFilter, limit: Int) -> Single<[TransactionRecord]>
    func rawTransaction(hash: String) -> String?
}

protocol ISendBitcoinAdapter {
    var balanceData: BalanceData { get }
    func availableBalance(feeRate: Int, address: String?, pluginData: [UInt8: IBitcoinPluginData]) -> Decimal
    func maximumSendAmount(pluginData: [UInt8: IBitcoinPluginData]) -> Decimal?
    func minimumSendAmount(address: String?) -> Decimal
    func validate(address: String, pluginData: [UInt8: IBitcoinPluginData]) throws
    func fee(amount: Decimal, feeRate: Int, address: String?, pluginData: [UInt8: IBitcoinPluginData]) -> Decimal
    func sendSingle(amount: Decimal, address: String, feeRate: Int, pluginData: [UInt8: IBitcoinPluginData], sortMode: TransactionDataSortMode, logger: Logger) -> Single<Void>
}

protocol ISendDashAdapter {
    func availableBalance(address: String?) -> Decimal
    func minimumSendAmount(address: String?) -> Decimal
    func validate(address: String) throws
    func fee(amount: Decimal, address: String?) -> Decimal
    func sendSingle(amount: Decimal, address: String, sortMode: TransactionDataSortMode, logger: Logger) -> Single<Void>
}
