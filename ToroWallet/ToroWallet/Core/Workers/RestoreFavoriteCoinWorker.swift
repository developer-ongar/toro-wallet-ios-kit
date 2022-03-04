import MarketKit
import StorageKit

class RestoreFavoriteCoinWorker {
    private let localStorageKey = "restore-favorite-coin-worker-run"

    private let coinManager: CoinManager
    private let favoritesManager: FavoritesManager
    private let localStorage: StorageKit.ILocalStorage
    private let storage: IFavoriteCoinRecordStorage

    init(coinManager: CoinManager, favoritesManager: FavoritesManager, localStorage: StorageKit.ILocalStorage, storage: IFavoriteCoinRecordStorage) {
        self.coinManager = coinManager
        self.favoritesManager = favoritesManager
        self.localStorage = localStorage
        self.storage = storage
    }

}
