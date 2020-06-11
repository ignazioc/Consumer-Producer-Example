import Foundation

class Kitchen {
    typealias KitchenReadyCallback = (Result<[Burgers], KitchenError>) -> Void
    enum State {
        case busy, free
    }

    public var currentState: State = .free

    func makeMoreBurgers(_ callback: @escaping KitchenReadyCallback) {
        currentState = .busy
        let burgersCount = Int.random(in: 1..<5)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.currentState = .free
            var burgers: [Burgers] = []
            for _ in 1...burgersCount {
                burgers.append(Burgers())
            }
            callback(.success(burgers))
        }
    }
}


public enum KitchenError: Error {
    case onFire
}
