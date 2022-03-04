import UIKit
import MarketKit

extension MarketKit.CoinType {

    var blockchainType: String? {
        switch self {
        case .erc20: return "ERC20"
        case .bep20: return "BEP20"
        case .bep2: return "BEP2"
        default: ()
        }

        return nil
    }

    var platformType: String {
        switch self {
        case .ethereum, .erc20: return "Ethereum"
        case .binanceSmartChain, .bep20: return "Binance Smart Chain"
        case .bep2: return "Binance"
        default: return ""
        }
    }

    var platformCoinType: String {
        switch self {
        case .ethereum, .binanceSmartChain: return "coin_platforms.native".localized
        case .erc20: return "ERC20"
        case .bep20: return "BEP20"
        case .bep2: return "BEP2"
        default: return ""
        }
    }
