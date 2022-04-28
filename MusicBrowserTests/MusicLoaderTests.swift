//
//  MusicLoaderTests.swift
//  MusicBrowserTests
//
//  Created by Mohammad Rahchamani on 4/28/22.
//

import XCTest
import Combine
import MusicBrowser

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
