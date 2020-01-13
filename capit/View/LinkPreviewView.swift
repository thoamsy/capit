//
//  LinkPreviewView.swift
//  capit
//
//  Created by yk on 1/13/20.
//  Copyright © 2020 Thoams Yang. All rights reserved.
//

import LinkPresentation
import SwiftUI

struct LinkPreviewView: UIViewRepresentable {
  var url: URL?
  @State var fetchMetadata: LPLinkMetadata?

  init?(url: String) {
    let originURL = URL(string: url)
    self.url = originURL
  }

    private func fetchMetadataWithProvider(onFetched: @escaping (LPLinkMetadata?, String?) -> Void) {
    guard let url = url else { return }
    let metaProvider = LPMetadataProvider()
    metaProvider.startFetchingMetadata(for: url) {
      metadata, error in
      if error != nil {
        let providerError = error as! LPError
        print(providerError.errorUserInfo)
        switch providerError.code {
        case .metadataFetchFailed:
            onFetched(nil, "Fetch Failed")
        case .metadataFetchTimedOut:
          print("Fetch time out")
        case .metadataFetchCancelled:
          print("cancel, do nothing")
          case .unknown:
          fallthrough
          @unknown default:
          print("unknown error.")
        }
        return
      }
        print(metadata)
      onFetched(metadata, nil)
    }
  }

  func makeUIView(context: UIViewRepresentableContext<LinkPreviewView>) -> LPLinkView {
    let metadata = LPLinkMetadata()
    metadata.originalURL = url
    metadata.url = metadata.originalURL
    metadata.title = "Loading…"

    let linkview = LPLinkView(metadata: metadata)
    linkview.sizeToFit()

    return linkview
  }

  func updateUIView(_ uiView: LPLinkView, context: UIViewRepresentableContext<LinkPreviewView>) {
    fetchMetadataWithProvider {
        metadata, error in
        if error != nil {
            return
        }
        DispatchQueue.main.async {
            uiView.metadata = metadata!
            uiView.sizeToFit()
        }
    }
  }
}

struct LinkPreviewView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      LinkPreviewView(url: "https://www.bilibili.com/video/av81333625?from=search&seid=7570804713215703946")
        LinkPreviewView(url: "https://podcasts.apple.com/cn/podcast/%E8%BD%AF%E4%BB%B6%E9%82%A3%E4%BA%9B%E4%BA%8B%E5%84%BF/id1147186605")
            .environment(\.colorScheme, .dark)
            .frame(height: 100)
    }.previewLayout(.sizeThatFits)
  }
}
