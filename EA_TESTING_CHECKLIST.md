# EA-Based Telegram Alert System - Testing Checklist

Use this checklist to verify your EA is working correctly before live trading.

## 🎯 Pre-Testing Preparation

- [ ] **Install MT4** on your computer
- [ ] **Copy EA file** (`PriceActionTelegramAlerts.mq4`) to `MQL4\Experts\` folder
- [ ] **Copy your indicator** (.ex4 file) to `MQL4\Indicators\` folder
- [ ] **Create Telegram bot** and get bot token
- [ ] **Get your Telegram chat ID**
- [ ] **Identify buffer numbers** for your indicator (Ctrl+D in MT4)

## 🔧 Basic Configuration Test

### Step 1: Attach Indicator
- [ ] Open MT4 and create a new chart
- [ ] Attach your compiled indicator to the chart
- [ ] Verify indicator is working (shows signals visually)
- [ ] Note the exact .ex4 filename (case-sensitive)

### Step 2: Attach EA
- [ ] Drag `PriceActionTelegramAlerts` from Navigator to chart
- [ ] Open EA properties (right-click → Expert Advisors → Properties)
- [ ] Go to Inputs tab

### Step 3: Configure Basic Settings
- [ ] Set `IndicatorName` to your .ex4 filename
- [ ] Set `BuyBufferNumber` (from your Data Window analysis)
- [ ] Set `SellBufferNumber` (from your Data Window analysis)
- [ ] Set `SignalTiming` to `ENTRY_SAME_CANDLE` (most common)
- [ ] Set `UseCurrentTimeframe` to `true`
- [ ] Set `EnableDebugMode` to `true`
- [ ] Set `SendPopupAlert` to `true`
- [ ] Set `EnableTelegramAlerts` to `false` (test without Telegram first)

## 🧪 Signal Detection Test

### Step 4: Enable Debug Mode
- [ ] Ensure `EnableDebugMode = true`
- [ ] Open MT4 Experts tab (View → Toolbox → Experts)
- [ ] Clear any existing messages

### Step 5: Monitor for Signals
- [ ] Wait for your indicator to generate a signal
- [ ] Check Experts tab for debug messages:
  - [ ] Look for: `Signal detected: BUY | Buffer=X, Value=Y, Bar=0, TF=Z`
  - [ ] Look for: `Alert triggered: BUY | Price: X.XXXXX`
  - [ ] Look for: `Signal detected: SELL | Buffer=X, Value=Y, Bar=0, TF=Z`
  - [ ] Look for: `Alert triggered: SELL | Price: X.XXXXX`

### Step 6: Verify Popup Alerts
- [ ] When signal appears, check for MT4 popup alert
- [ ] Verify popup shows correct signal type (BUY/SELL)
- [ ] Verify popup shows correct symbol and timeframe
- [ ] Verify popup shows correct price

## 📱 Telegram Integration Test

### Step 7: Configure Telegram
- [ ] Set `EnableTelegramAlerts = true`
- [ ] Set `TelegramBotToken` to your bot token
- [ ] Set `TelegramChatID` to your chat ID
- [ ] Keep `EnableDebugMode = true`

### Step 8: Test Telegram Alert
- [ ] Wait for next signal to appear
- [ ] Check Experts tab for: `Telegram alert sent: true`
- [ ] Open Telegram and check your chat with the bot
- [ ] Verify you received a message with format:
  ```
  🔔 TRADING SIGNAL

  📊 Asset: EURUSD
  ⏱️ Timeframe: H1
  🎯 Signal: BUY
  💰 Price: 1.0850
  ⌚ Time: 2026-01-15 14:30:00

  From: MyPriceAction.ex4
  ```
- [ ] Verify all fields are correct (symbol, timeframe, signal type, price, time)

## ⚙️ Advanced Configuration Test

### Step 9: Test Different Timeframes
- [ ] Set `UseCurrentTimeframe = false`
- [ ] Set `CustomTimeframe = PERIOD_H4`
- [ ] Verify signals are detected on H4 timeframe
- [ ] Check that alerts show correct timeframe

### Step 10: Test Signal Timing
- [ ] Set `SignalTiming = ENTRY_NEXT_CANDLE`
- [ ] Verify signals trigger on next candle open
- [ ] Compare with `ENTRY_SAME_CANDLE` behavior

### Step 11: Test Duplicate Prevention
- [ ] Set `DuplicatePreventionBars = 1` (minimal)
- [ ] Generate multiple signals in quick succession
- [ ] Verify only one alert is sent per signal
- [ ] Increase to `DuplicatePreventionBars = 10`
- [ ] Verify alerts are properly spaced

## 🔊 Alert Methods Test

### Step 12: Test All Alert Types
- [ ] Set `SendPopupAlert = true`
- [ ] Set `PlaySoundAlert = true`
- [ ] Set `SendEmailAlert = true` (if email configured)
- [ ] Set `EnableTelegramAlerts = true`
- [ ] Trigger a signal
- [ ] Verify popup alert appears
- [ ] Verify sound plays
- [ ] Verify email is sent (if configured)
- [ ] Verify Telegram message is received

### Step 13: Test Performance Tracking
- [ ] Set `EnablePerformanceTracking = true`
- [ ] Set `PerformanceTrackingBars = 5` (short period for testing)
- [ ] Set `TakeProfitPips = 50.0`
- [ ] Set `StopLossPips = 30.0`
- [ ] Trigger a signal and wait for PerformanceTrackingBars to elapse
- [ ] Verify performance summary is sent to Telegram
- [ ] Check that statistics are updated correctly
- [ ] Verify win/loss determination is accurate
- [ ] Test multiple trades to see cumulative statistics

## 🐞 Error Handling Test

### Step 14: Test Error Conditions
- [ ] Set `IndicatorName` to wrong filename
- [ ] Verify error message in Experts tab
- [ ] Set `BuyBufferNumber` to invalid value (e.g., 8)
- [ ] Verify error message in Experts tab
- [ ] Set `TelegramBotToken` to empty
- [ ] Verify warning message
- [ ] Set `TelegramChatID` to empty
- [ ] Verify warning message

### Step 15: Test Network Issues
- [ ] Disable internet connection
- [ ] Trigger a signal
- [ ] Verify retry logic works (check Experts tab)
- [ ] Re-enable internet
- [ ] Verify next signal works normally

## 📊 Performance Test

### Step 16: Stress Test
- [ ] Attach EA to multiple charts
- [ ] Use different symbols (EURUSD, GBPUSD, etc.)
- [ ] Monitor CPU usage in Task Manager
- [ ] Verify no performance degradation
- [ ] Verify all charts receive alerts correctly

### Step 17: Long-Running Test
- [ ] Let EA run for 24 hours
- [ ] Monitor Experts tab for errors
- [ ] Verify no memory leaks
- [ ] Verify consistent signal detection

## 🎓 User Acceptance Test

### Step 18: Real Trading Conditions
- [ ] Use demo account with real market data
- [ ] Monitor signals during active market hours
- [ ] Verify signals match your indicator's visual signals
- [ ] Verify alert timing is appropriate
- [ ] Verify no false positives or missed signals

### Step 19: Compare with Manual Trading
- [ ] Manually identify signals on chart
- [ ] Verify EA detects same signals
- [ ] Verify alert timing matches your expectations
- [ ] Verify signal quality is maintained

## ✅ Final Verification

### Step 20: Production Configuration
- [ ] Set `EnableDebugMode = false`
- [ ] Set `DuplicatePreventionBars = 5` (recommended)
- [ ] Set `MaxRetries = 3` (recommended)
- [ ] Set `RetryDelayMS = 2000` (recommended)
- [ ] Enable only desired alert methods

### Step 21: Final Test
- [ ] Trigger one final signal
- [ ] Verify all systems work correctly
- [ ] Verify no debug messages appear
- [ ] Verify clean operation

## 📋 Checklist Summary

### Basic Functionality
- [ ] Indicator attached and working
- [ ] EA attached and running
- [ ] Signal detection working (debug mode)
- [ ] Popup alerts working
- [ ] Telegram alerts working
- [ ] Performance tracking working

### Configuration
- [ ] Correct indicator name
- [ ] Correct buffer numbers
- [ ] Correct signal timing
- [ ] Correct timeframe settings
- [ ] Appropriate duplicate prevention
- [ ] Performance tracking parameters set

### Alert Methods
- [ ] Telegram alerts functional
- [ ] Popup alerts functional
- [ ] Sound alerts functional (if enabled)
- [ ] Email alerts functional (if enabled)
- [ ] Performance reports functional

### Error Handling
- [ ] Invalid configuration detected
- [ ] Network issues handled gracefully
- [ ] Retry logic working
- [ ] No crashes or memory leaks

### Performance
- [ ] Low CPU usage
- [ ] Stable long-term operation
- [ ] Multiple chart support
- [ ] No performance degradation

## 🚀 Ready for Live Use

Once all checks are complete:
- [ ] Save chart template for easy reloading
- [ ] Document your configuration
- [ ] Monitor first few live signals
- [ ] Gradually increase confidence
- [ ] Enjoy automated alerts!

## 📞 Troubleshooting Tips

If any test fails:
1. **Check Experts tab** for error messages
2. **Enable debug mode** for detailed logging
3. **Verify buffer numbers** with Data Window (Ctrl+D)
4. **Test indicator independently** first
5. **Check Telegram bot** is working manually
6. **Review this checklist** for missed steps
7. **Consult EA_SETUP_GUIDE.md** for detailed instructions

## 📝 Notes

- Always test with demo accounts first
- Never rely solely on automated alerts for trading
- Verify signals manually before making trading decisions
- Monitor system regularly for optimal performance
- Keep MT4 and EA updated for best results
