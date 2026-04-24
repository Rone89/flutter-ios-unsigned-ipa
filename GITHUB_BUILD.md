# GitHub unsigned iOS IPA build

This repository is prepared for GitHub Actions unsigned iOS builds.

## Upload steps

1. Upload the entire contents of this folder to a GitHub repository:

   `D:\workspace\flutterIOS`

2. Open GitHub Actions.

3. Run the workflow:

   `Build unsigned iOS IPA`

4. Download the artifact:

   `PiliPlus-unsigned-ipa`

## Important notes

- The generated IPA is unsigned. It is mainly useful for later re-signing.
- A normal non-jailbroken iPhone will not install an unsigned IPA directly.
- The iOS 26 native UI package lives at:

  `packages/piliplus_native_ios26`

- If GitHub's runner Xcode does not include the iOS 26 SDK, Liquid Glass APIs may fail to compile. In that case, switch the workflow runner/Xcode version when GitHub provides one with the iOS 26 SDK, or temporarily disable the Liquid Glass branches in the Swift package.
