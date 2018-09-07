import XCTest
import Foundation // for the sleep function
@testable import uProgressbar

func sleep(_ duration: Double) {
    let second = 1000000
    usleep(useconds_t(duration * Double(second)))
}

final class uProgressbarTests: XCTestCase {
    func test() {
        /* well, I don't know how I should test a progressbar,
         * so it just runs once and that's it.
         */
        // init progressbar:
        let progress = ProgressBar(width: 50)
        // let it run:
        let total = 100
        for _ in 1...total {
            sleep(0.1)
            progress.update(
                amount: 1.0 / Double(total)
            )
        }
    }

    static var allTests = [
        ("testExample", test),
    ]
}
