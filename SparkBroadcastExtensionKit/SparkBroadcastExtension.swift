// Copyright 2016-2017 Cisco Systems Inc
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import SparkSDKBroadcastUtil

public enum BroadcastExtensionState : String{
    case Initiated
    case Broadcasting
    case Suspended
    case Stopped
}


@available (iOS 11.2,*)
public class SparkBroadcastExtension {
    
    public static let sharedInstance = SparkBroadcastExtension()
    
    private var applicationGroupIdentifier: String?
    private var broadcastClient: SparkBroadcastClient?
    
    /// Callback when broadcast screen error occurred.
    ///
    /// - since: 1.4.0
    public var onError: ((SparkError) -> Void)? {
        didSet {
            self.broadcastClient?.onError = self.onError
        }
    }
    
    /// Callback when this broadcast session state changed.
    ///
    /// - since: 1.4.0
    public var onStateChange: ((BroadcastExtensionState) -> Void)? {
        didSet {
            self.broadcastClient?.onStateChange = self.onStateChange
        }
    }
    
    /// Broadcast session state.
    ///
    /// - since: 1.4.0
    public var broadcastState: BroadcastExtensionState? {
        get {
            return self.broadcastClient?.broadcastState
        }
    }
    
    /// start broadcast session, transfer frame data to the extension containing app.
    ///
    /// - since: 1.4.0
    public func start(applicationGroupIdentifier appID:String,completionHandler: @escaping ((SparkError?) -> Void)) {
        if appID.count > 0, self.broadcastClient == nil {
            self.broadcastClient = SparkBroadcastClient.init(applicationGroupIdentifier: appID)
        }
        self.broadcastClient?.start(completionHandler: completionHandler)
    }
    
    /// Push a screen video frame data to the extension containing app.
    ///
    /// - since: 1.4.0
    public func handleVideoSampleBuffer(sampleBuffer:CMSampleBuffer) {
        self.broadcastClient?.pushVideoSampleBuffer(sampleBuffer: sampleBuffer)
    }
    
    /// finish broadcast session.
    ///
    /// - since: 1.4.0
    public func finish() {
        self.broadcastClient?.finishClient()
        self.broadcastClient = nil
    }
    
    private init() {}
}

