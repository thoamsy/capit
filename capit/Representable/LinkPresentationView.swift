//
//  LinkPreviewView.swift
//  capit
//
//  Created by yk on 1/13/20.
//  Copyright © 2020 Thoams Yang. All rights reserved.
//

import LinkPresentation
import SwiftUI

struct LinkPresentationView: UIViewRepresentable {
  var url: URL?
  @Binding var redraw: Bool

  init?(url: String, redraw: Binding<Bool>) {
    let originURL = URL(string: url)
    self.url = originURL
    _redraw = redraw
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
      onFetched(metadata, nil)
    }
  }

  func makeUIView(context: UIViewRepresentableContext<LinkPresentationView>) -> LPLinkView {
    var metadata = LPLinkMetadata()
    metadata.originalURL = url
    metadata.url = metadata.originalURL
    metadata.title = "Loading…"

    if let metadataFromStorage = MetadataStorage.metadata(for: url!) {
      metadata = metadataFromStorage
    }
    let linkview = LPLinkView(metadata: metadata)
    linkview.sizeToFit()

    fetchMetadataWithProvider {
      metadata, error in
      if error != nil {
        return
      }
      MetadataStorage.store(metadata!)
      DispatchQueue.main.async {
        linkview.metadata = metadata!
        linkview.sizeToFit()
        self.redraw.toggle()
      }
    }

    return linkview
  }

  func updateUIView(_ uiView: LPLinkView, context: UIViewRepresentableContext<LinkPresentationView>) {
  }
}

struct LinkPreviewView_Previews: PreviewProvider {
  @State var redraw = false

  static var previews: some View {
    Group {
      LinkPresentationView(url: "https://medium.com/flawless-app-stories/context-menu-alert-and-actionsheet-in-swiftui-b6ff0d1f8493", redraw: .constant(false))
      LinkPresentationView(url: "https://medium.com/better-programming/ios-13-rich-link-previews-with-swiftui-e61668fa2c69", redraw: .constant(false))
      LinkPresentationView(url: "https://podcasts.apple.com/cn/podcast/%E8%BD%AF%E4%BB%B6%E9%82%A3%E4%BA%9B%E4%BA%8B%E5%84%BF/id1147186605", redraw: .constant(false))
        .environment(\.colorScheme, .dark)

    }.frame(height: 100).previewLayout(.sizeThatFits)
  }
}
