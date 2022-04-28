//
//  MusicLoaderTests.swift
//  MusicBrowserTests
//
//  Created by Mohammad Rahchamani on 4/28/22.
//

import XCTest
import Combine

class URLProtocolStub: URLProtocol {
    
    struct Stub {
        var data: Data?
        var response: URLResponse?
        var error: Error?
    }
    
    static var observer: ((URLRequest) -> ())?
    static var stub: Stub?
    
    static func observe(_ closure: @escaping (URLRequest) -> ()) {
        observer = closure
    }
    
    static func stub(withData data: Data?,
                     response: URLResponse?,
                     error: Error?) {
        stub = Stub(data: data,
                    response: response,
                    error: error)
    }
    
    static func startIntercepting() {
        URLProtocol.registerClass(self)
    }
    
    static func stopIntercepting() {
        URLProtocol.unregisterClass(self)
        observer = nil
        stub = nil
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        URLProtocolStub.observer?(request)
        guard let stub = URLProtocolStub.stub else { return }
        if let data = stub.data {
            client?.urlProtocol(self, didLoad: data)
        }
        if let response = stub.response {
            client?.urlProtocol(self,
                                didReceive: response,
                                cacheStoragePolicy: .notAllowed)
        }
        if let error = stub.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
    
}


class MusicLoader {
    
    private let session: URLSession
    private let url: URL
    
    init(session: URLSession, url: URL) {
        self.session = session
        self.url = url
    }
    
    func load() -> AnyPublisher<Void, Error> {
        session.dataTaskPublisher(for: self.url)
            .map { _ in () }
            .mapError { err in err as Error }
            .eraseToAnyPublisher()
    }
    
}

class MusicLoaderTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        URLProtocolStub.startIntercepting()
        cancellables.forEach {
            $0.cancel()
        }
        cancellables.removeAll()
    }

    override func tearDownWithError() throws {
        URLProtocolStub.stopIntercepting()
    }

    func test_init_doesNotRequestNetwork() {
        var requestCallCount = 0
        URLProtocolStub.observe { _ in
            requestCallCount += 1
        }
        _ = makeSUT()
        XCTAssertEqual(requestCallCount, 0)
    }
    
    func test_load_failsOnNetworkError() {
        URLProtocolStub.stub(withData: nil, response: nil, error: NSError(domain: "", code: 0, userInfo: nil))
        let sut = makeSUT()
        let exp = XCTestExpectation(description: "waiting for load")
        sut.load()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail()
                default:
                    ()
                }
                exp.fulfill()
            }, receiveValue: { _ in })
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 1)
    }
    
    // MARK: - helpers
    
    func makeSUT(file: StaticString = #filePath,
                 line: UInt = #line) -> MusicLoader {
        let sut = MusicLoader(session: .shared, url: URL(string: "https://any-url.com")!)
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
    
    func trackForMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "instance should be nil", file: file, line: line)
        }
    }
    
    func anyNSError() -> NSError {
        NSError(domain: "test domain", code: 1, userInfo: nil)
    }

}
