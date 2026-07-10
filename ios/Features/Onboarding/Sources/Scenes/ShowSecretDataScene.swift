// Copyright (c). Gem Wallet. All rights reserved.

import Components
import InfoSheet
import Localization
import Primitives
import PrimitivesComponents
import Style
import SwiftUI

struct ShowSecretDataScene: View {
    let model: any SecretPhraseViewableModel
    @State private var isPresentingCopyToast = false
    @State private var isPresentingInfoSheet: InfoSheetType?

    var body: some View {
        List {
            if let calloutViewStyle = model.calloutViewStyle {
                Section {
                    CalloutView(style: calloutViewStyle)
                }
                .cleanListRow()
            }

            Section {
                SecretDataTypeView(type: model.type)
            }
            .cleanListRow()

            ListButton(
                title: Localized.Common.copy,
                image: Images.System.copy,
                action: copy,
            )
            .frame(maxWidth: .infinity, alignment: .center)
            .cleanListRow()
        }
        .safeAreaButton(isVisible: model.continueAction != nil) {
            StateButton(
                text: Localized.Common.continue,
                action: continueAction,
            )
        }
        .contentMargins([.top], .extraSmall, for: .scrollContent)
        .listSectionSpacing(.custom(.medium))
        .toolbarInfoButton(url: model.docsUrl)
        .navigationTitle(model.title)
        .copyToast(
            model: model.copyModel,
            isPresenting: $isPresentingCopyToast,
        )
        .sheet(item: $isPresentingInfoSheet) {
            InfoSheetScene(type: $0)
        }
        .detectScreenshots(docsUrl: model.docsUrl)
        .protectFromScreenRecording()
    }

    private func copy() {
        isPresentingInfoSheet = .reminderCopyingSecretPhrase(action: onConfirmCopy)
    }

    private func onConfirmCopy() {
        isPresentingInfoSheet = nil
        isPresentingCopyToast = true
    }

    func continueAction() {
        model.continueAction?()
    }
}
