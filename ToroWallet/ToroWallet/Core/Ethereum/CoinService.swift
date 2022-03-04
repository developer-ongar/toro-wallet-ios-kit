import CurrencyKit
import BigInt
import MarketKit

class CoinService {
    let platformCoin: PlatformCoin
    private let currencyKit: CurrencyKit.Kit
    private let marketKit: MarketKit.Kit

    init(platformCoin: PlatformCoin, currencyKit: CurrencyKit.Kit, marketKit: MarketKit.Kit) {
        self.platformCoin = platformCoin
        self.currencyKit = currencyKit
        self.marketKit = marketKit
    }

}
