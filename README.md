# SiriVoicePayments

Voice-first payment initiation POC for iOS using SwiftUI, App Intents, and App Shortcuts.

# Quick Look at the POC.

<img width="736" height="1436" alt="image" src="https://github.com/user-attachments/assets/54aac141-1816-4551-b53e-d1059f5fbf62" />


## ✨ Highlights

- 🎙️ Trigger a payment-prep flow from Siri or Shortcuts.
- 👤 Resolve saved beneficiaries with `AppEntity` + `EntityQuery`.
- 📱 Open the app with a prefilled draft and confirm inside the UI.
- 🔐 Keep the final payment step inside the app instead of silently transferring money.

## 🧱 Stack

- SwiftUI
- App Intents
- App Shortcuts
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

1. 🚀 App starts and registers shortcuts with `updateAppShortcutParameters()`.
2. 🎙️ Siri or Shortcuts runs the payment intent.
3. 👤 The app resolves the beneficiary using app entities.
4. 🧾 A draft payment is created.
5. ✅ The app opens a confirmation screen.

## 🛠️ Run locally

1. Clone the repo.
2. Open the project in Xcode.
3. Build and run on simulator or device.
4. For better Siri name recognition, add `INAlternativeAppNames` in `Info.plist`.

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

- 🧪 Simulator is okay for basic validation, but Siri/App Shortcuts behavior can be inconsistent there.
- 💳 A free Personal Team can run normal device builds, but Siri capability is not supported for Personal Team provisioning.
- 🏢 For a real Siri-enabled device demo, use a paid Apple Developer account.

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
