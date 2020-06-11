
import Cocoa
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true


let orderCollector = OrderCollector()

for n in 1...10 {
    orderCollector.getHamburger {
        switch $0 {
        case .success:
            print("C\(n): Thanks!")
        case .failure:
            print("C\(n): Ok, nevermind.")
        }
    }
}


