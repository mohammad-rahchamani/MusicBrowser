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

struct MusicAlbum: Equatable, Codable {
    public let id: String
    public let album: String
    public let artist: String
    public let cover: String
    public let label: String
    public let tracks: [String]
    public let year: String
}

class MusicLoader {
    
    private let session: URLSession
    private let url: URL
    
    init(session: URLSession, url: URL) {
        self.session = session
        self.url = url
    }
    
    func load() -> AnyPublisher<[MusicAlbum], Error> {
        session.dataTaskPublisher(for: self.url)
            .map(\.data)
            .decode(type: [MusicAlbum].self, decoder: JSONDecoder())
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
        let sut = makeSUT()
        expectFailure(sut, stubbing: .init(data: nil,
                                           response: nil,
                                           error: anyNSError()))
    }
    
    func test_load_failsOnInvalidData() {
        let sut = makeSUT()
        expectFailure(sut, stubbing: .init(data: Data(),
                                           response: successResponse(),
                                           error: nil))
    }
    
    func test_load_deliversData() {
        let sut = makeSUT()
        let expectedAlbums = [anyAlbum(), anyAlbum(), anyAlbum()]
        let encodedAlbums = data(from: expectedAlbums)
        expectLoad(sut,
                   result: expectedAlbums,
                   stubbing: .init(data: encodedAlbums,
                                   response: successResponse(),
                                   error: nil))
    }
    
    // MARK: - helpers
    
    func makeSUT(file: StaticString = #filePath,
                 line: UInt = #line) -> MusicLoader {
        let sut = MusicLoader(session: .shared, url: anyURL())
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
    
    func expectFailure(_ sut: MusicLoader,
                       stubbing stub: URLProtocolStub.Stub,
                       file: StaticString = #filePath,
                       line: UInt = #line) {
        URLProtocolStub.stub(withData: stub.data,
                             response: stub.response,
                             error: stub.error)
        let exp = XCTestExpectation(description: "waiting for load")
        sut.load()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail(file: file, line: line)
                default:
                    ()
                }
                exp.fulfill()
            }, receiveValue: { _ in })
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 1)
    }
    
    func expectLoad(_ sut: MusicLoader,
                    result expectedResult: [MusicAlbum],
                    stubbing stub: URLProtocolStub.Stub,
                    file: StaticString = #filePath,
                    line: UInt = #line) {
        URLProtocolStub.stub(withData: stub.data,
                             response: stub.response,
                             error: stub.error)
        let exp = XCTestExpectation(description: "waiting for load")
        sut.load()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    XCTFail(file: file, line: line)
                default:
                    ()
                }
                exp.fulfill()
            }, receiveValue: { result in
                XCTAssertEqual(result, expectedResult)
            })
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 1)
    }
    
    func trackForMemoryLeak(_ instance: AnyObject,
                            file: StaticString = #filePath,
                            line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "instance should be nil", file: file, line: line)
        }
    }
    
    func anyURL() -> URL {
        URL(string: "https://any-url.com")!
    }
    
    func successResponse() -> URLResponse {
        HTTPURLResponse(url: anyURL(),
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil)!
    }
    
    func anyAlbum() -> MusicAlbum {
        MusicAlbum(id: "id",
                   album: "album",
                   artist: "artist",
                   cover: "cover",
                   label: "label",
                   tracks: ["track"],
                   year: "year")
    }
    
    func data(from albums: [MusicAlbum]) -> Data {
        return try! JSONEncoder().encode(albums)
    }
    
    func anyNSError() -> NSError {
        NSError(domain: "test domain", code: 1, userInfo: nil)
    }

}
