# Pricing Configuration

## Monetization Model: Freemium (Free + Non-Consumable IAP)

- **Download Price**: Free
- **IAP Type**: Non-Consumable (One-Time Purchase)
- **Subscription**: None
- **Rationale**: Pure offline app with zero ongoing costs (no API, no server). One-time purchase aligns with user expectations for utility apps in small-language markets. Subscription would face resistance in the Catalan market.

## Free Tier (Forever Available)

- Catalan spell checking (basic dictionary, 30,000 words)
- Autocorrect (edit distance 1)
- Word prediction (basic 3-word candidates)
- Catalan-Spanish bilingual switching
- Standard QWERTY keyboard layout
- Basic haptic feedback

### Free Tier Limitations
- No dialect support (Balearic/Valencian)
- No professional dictionaries (legal/medical/education)
- No custom dictionary
- No advanced autocorrect (edit distance 2)
- No theme customization

## Pro Upgrade (One-Time Purchase)

- **Reference Name**: CatKey Pro
- **Product ID**: `com.zzoutuo.CatKey.pro`
- **Price**: $3.99 / €3.99 (Tier 4)
- **Display Name**: CatKey Pro
- **Description**: Full Catalan keyboard with all features

### Pro Features Unlocked
- Complete dictionary (50,000+ words)
- Advanced autocorrect (edit distance 1-2)
- Enhanced word prediction (5-word candidates)
- Dialect support (Balearic / Valencian)
- Professional dictionaries (legal / medical / education)
- Custom dictionary (add / delete / import)
- Theme customization (5+ themes)
- Keyboard height adjustment
- No ads
- Priority support

## App Store Connect Pricing
- **Price Tier**: Free (download)
- **IAP Tier**: Tier 4 ($3.99)

## Policy Pages Required
- Support Page: ✅
- Privacy Policy: ✅
- Terms of Use: ✅ (Required for IAP apps per Guideline 3.1.2(c))

## Apple IAP Compliance Checklist
- [x] Non-consumable product type (one-time purchase)
- [x] Restore purchases functionality implemented
- [x] No dark patterns in paywall
- [x] Free tier is fully functional (not a trial)
- [x] Pro features clearly listed in paywall
- [x] Privacy Policy link in paywall
- [x] Terms of Use link in paywall
