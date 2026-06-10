# SiriVoicePayments

Voice-first payment initiation POC for iOS using SwiftUI, App Intents, and App Shortcuts.[1][2]

## ✨ Highlights

- 🎙️ Trigger a payment-prep flow from Siri or Shortcuts.[1][2]
- 👤 Resolve saved beneficiaries with `AppEntity` + `EntityQuery`.[1][3]
- 📱 Open the app with a prefilled draft and confirm inside the UI.
- 🔐 Keep the final payment step inside the app instead of silently transferring money.[2][4]

## 🧱 Stack

- SwiftUI
- App Intents[1]
- App Shortcuts[3]
- iOS 18+

## 📂 Structure

```text
SiriVoicePayments/
├── SiriVoicePaymentsApp.swift
├── ContentView.swift
├── Models/
│   ├── Beneficiary.swift
│   └── SiriVoicePaymentDraft.swift
├── Data/
│   └── SiriVoiceBeneficiaryRepository.swift
├── State/
│   └── SiriVoicePaymentDraftStore.swift
├── Intents/
│   ├── BeneficiaryEntity.swift
│   ├── BeneficiaryQuery.swift
│   ├── SiriVoicePaymentIntent.swift
│   └── SiriVoicePaymentsShortcutsProvider.swift
├── Features/
│   ├── Home/
│   │   └── SiriVoicePaymentsHomeView.swift
│   └── ConfirmPayment/
│       └── ConfirmSiriVoicePaymentView.swift
└── Resources/
```

## ⚙️ Flow

1. 🚀 App starts and registers shortcuts with `updateAppShortcutParameters()`.[5][6]
2. 🎙️ Siri or Shortcuts runs the payment intent.[1][2]
3. 👤 The app resolves the beneficiary using app entities.[1][3]
4. 🧾 A draft payment is created.
5. ✅ The app opens a confirmation screen.

## 🛠️ Run locally

1. Clone the repo.
2. Open the project in Xcode.
3. Build and run on simulator or device.
4. For better Siri name recognition, add `INAlternativeAppNames` in `Info.plist`.[5]

```xml
<key>INAlternativeAppNames</key>
<array>
  <dict>
    <key>INAlternativeAppName</key>
    <string>Siri Voice Payments</string>
    <key>INAlternativeAppNamePronunciationHint</key>
    <string>Siri Voice Payments</string>
  </dict>
</array>
```

## 📱 Device notes

- 🧪 Simulator is okay for basic validation, but Siri/App Shortcuts behavior can be inconsistent there.[5][7]
- 💳 A free Personal Team can run normal device builds, but Siri capability is not supported for Personal Team provisioning.[8][9]
- 🏢 For a real Siri-enabled device demo, use a paid Apple Developer account.[8][9]

## 🚧 Limitations

- No real UPI or bank transfer.
- No production auth, compliance, or fraud checks.
- Confirmation-first flow only.[2][4]

## 🔮 Next

- Face ID / biometric confirmation
- Real backend or sandbox payment integration
- Better shortcut coverage
- Transaction limits and allowlisting

## 📄 License

Demo / learning project.
