import XCTest
import Combine

extension XCTestCase {
    func awaitPublisher<T: Publisher>(_ publisher: T, timeout: TimeInterval = 10) throws -> T.Output {
        var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")

        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    result = .failure(error)
                case .finished:
                    break
                }

                expectation.fulfill()
            },
            receiveValue: { value in
                result = .success(value)
            }
        )

        wait(for: [expectation], timeout: timeout)
        cancellable.cancel()

        let unwrappedResult = try XCTUnwrap(result, "Awaited publisher did not produce any output")

        return try unwrappedResult.get()
    }
}
