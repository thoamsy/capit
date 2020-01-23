//
//  SafariView.swift
//  capit
//
//  Created by yk on 1/15/20.
//  Copyright © 2020 Thoams Yang. All rights reserved.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
  let url: URL
  let onFinished: () -> Void

  class Coordinator: NSObject, SFSafariViewControllerDelegate {
    let parent: SafariView
    init(_ parent: SafariView) {
      self.parent = parent
    }

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
      parent.onFinished()
    }
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
    let controller = SFSafariViewController(url: url)
    controller.delegate = context.coordinator
    return controller
  }

  func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {

  }
}

struct SafariView_Previews: PreviewProvider {
    static var previews: some View {
        SafariView(url: URL(string: "https://www.apple.com/newsroom/2020/01/share-your-best-iphone-night-mode-photos/")!, onFinished: {})
    }
}
