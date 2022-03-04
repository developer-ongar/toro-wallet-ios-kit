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
