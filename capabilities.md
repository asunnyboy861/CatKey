# Capabilities Configuration

## Analysis
Based on operation guide analysis:
- "购买" / "premium" / "Pro版" / "一次性买断" → In-App Purchase (non-consumable)
- "App Group" / "共享" → App Group (for keyboard extension data sharing)
- "键盘扩展" / "Keyboard Extension" → Custom Keyboard Extension
- "完全访问权限" / "Full Access" → Keyboard Full Access entitlement
- No iCloud, HealthKit, Location, Watch, Push Notifications, Camera needed
- Pure offline app — no network capabilities required

## Auto-Configured Capabilities
| Capability | Status | Method |
|------------|--------|--------|
| App Group | ✅ Will be configured | Xcode project setup (group.com.zzoutuo.CatKey.shared) |
| Custom Keyboard Extension | ✅ Will be configured | Xcode target addition |
| Keyboard Full Access | ✅ Will be configured | Info.plist RequestsOpenAccess = YES |
| In-App Purchase | ✅ Will be configured | Xcode Signing & Capabilities |

## Manual Configuration Required
| Capability | Status | Steps |
|------------|--------|-------|
| IAP Product Setup | ⏳ Pending | 1. Create non-consumable product in App Store Connect 2. Configure product ID: com.zzoutuo.CatKey.pro |

## No Configuration Needed
- iCloud: Not needed (pure offline, no sync)
- HealthKit: Not applicable
- Location Services: Not applicable
- Push Notifications: Not needed
- Camera/Photo Library: Not needed
- Apple Watch: Not needed
- Background Modes: Not needed
- Siri: Not needed

## Verification
- Build succeeded after configuration: ⏳ Pending (will verify after code generation)
- All entitlements correct: ⏳ Pending
