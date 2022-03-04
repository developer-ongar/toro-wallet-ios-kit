import RxSwift
import HsToolKit
import MarketKit
import StorageKit

class RestoreCustomTokenWorker {
    private let localStorageKey = "restore-custom-token-worker-run"

    private let coinManager: CoinManager
    private let walletManager: WalletManager
    private let storage: IEnabledWalletStorage
    private let localStorage: StorageKit.ILocalStorage
    private let networkManager: NetworkManager
    private let disposeBag = DisposeBag()

    init(coinManager: CoinManager, walletManager: WalletManager, storage: IEnabledWalletStorage, localStorage: StorageKit.ILocalStorage, networkManager: NetworkManager) {
        self.coinManager = coinManager
        self.walletManager = walletManager
        self.storage = storage
        self.localStorage = localStorage
        self.networkManager = networkManager
    }
