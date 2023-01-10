//
//  DownloadManager.swift
//  Lessons
//
//  Created by Mayur Shrivas on 09/01/23.
//

import UIKit

final class DownloadManager: NSObject {
    static let shared = DownloadManager()
    
    private let fileManager = FileManager.default

    private var dataTask: URLSessionDownloadTask?
    
    var isDownloading: Bool = false
    
    var downloadProgress: ((CGFloat) -> Void)?
    
    func downloadFile(videoUrl: String, downloadProgress: ((CGFloat) -> Void)?) {
        self.downloadProgress = downloadProgress
        isDownloading = true

        let destinationUrl = getFileUrlWith(videoUrl: videoUrl)
        if fileManager.fileExists(atPath: destinationUrl.path) {
            isDownloading = false
        } else {
            let urlRequest = URLRequest(url: URL(string: videoUrl)!)
            
            let configuration = URLSessionConfiguration.default
            let operationQueue = OperationQueue()
            let session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
            
            dataTask = session.downloadTask(with: urlRequest)
            dataTask?.resume()
        }
    }
    
    func checkFileExists(videoUrl: String) -> Bool {
        let destinationUrl = getFileUrlWith(videoUrl: videoUrl)
        return fileManager.fileExists(atPath: destinationUrl.path)
    }
    
    func cancelDownload() {
        dataTask?.cancel()
        dataTask = nil
    }

    // MARK: read downloaded data
    private func readDownloadedData(of url: URL) -> Data? {
        do {
            let reader = try FileHandle(forReadingFrom: url)
            let data = reader.readDataToEndOfFile()
            return data
        } catch {
            return nil
        }
    }
    
    private func getDocumentsDirectoryFolder() -> URL {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func getFileUrlWith(videoUrl: String) -> URL {
        let fileName = videoUrl.components(separatedBy: "/").last ?? ""
        let docsUrl = getDocumentsDirectoryFolder()
        return docsUrl.appendingPathComponent(fileName)
    }
}

extension DownloadManager: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        downloadProgress?(progress)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let videoData = readDownloadedData(of: location) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                do {
                    let destinationUrl = self.getFileUrlWith(videoUrl: self.dataTask?.currentRequest?.url?.absoluteString ?? "")
                    try videoData.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                    DispatchQueue.main.async {
                        self.isDownloading = false
                    }
                } catch {
                    self.isDownloading = false
                }
            }
        }
    }
}
