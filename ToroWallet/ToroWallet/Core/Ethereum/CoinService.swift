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

extension CoinService {

    var rate: CurrencyValue? {
        let baseCurrency = currencyKit.baseCurrency

        return marketKit.coinPrice(coinUid: platformCoin.coin.uid, currencyCode: baseCurrency.code).map { coinPrice in
            CurrencyValue(currency: baseCurrency, value: coinPrice.value)
        }
    }

    func coinValue(value: BigUInt) -> CoinValue {
        let decimalValue = Decimal(bigUInt: value, decimals: platformCoin.decimals) ?? 0
        return CoinValue(kind: .platformCoin(platformCoin: platformCoin), value: decimalValue)
    }
