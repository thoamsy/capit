//
//  LPView.swift
//  capit
//
//  Created by yk on 1/15/20.
//  Copyright © 2020 Thoams Yang. All rights reserved.
//

import SwiftUI

struct LPView: View {
  @State var redraw = false
  @State var toggleSafari = false

  let url: String

  init(url: String) {
    self.url = url
  }

  var body: some View {
    return LinkPresentationView(url: url, redraw: $redraw)
      .onTapGesture {
        self.toggleSafari = true
      }
      .sheet(isPresented: $toggleSafari) {
//        guard let url = URL(string: self.url) else { return EmptyView() }
        SafariView(
          url: URL(string: self.url)!,
          onFinished: {
            self.toggleSafari.toggle()
        })
      }
  }
}

struct LPView_Previews: PreviewProvider {
  static var previews: some View {
    LPView(url: "https://www.apple.com/newsroom/2020/01/share-your-best-iphone-night-mode-photos/")
  }
}
