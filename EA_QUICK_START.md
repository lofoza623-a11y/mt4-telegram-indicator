# EA-Based Telegram Alert System - Quick Start Guide

Get your EA running in 5 minutes with this quick start guide!

## 🚀 1-Minute Setup

### 1. Copy Files
```
Copy PriceActionTelegramAlerts.mq4 → MT4\MQL4\Experts\
Copy YourIndicator.ex4 → MT4\MQL4\Indicators\
```

### 2. Create Telegram Bot
1. Open Telegram, search `@BotFather`
2. Send `/newbot`, follow instructions
3. Copy your **Bot Token**
4. Send a message to your bot, get your **Chat ID**

### 3. Find Buffer Numbers
1. Attach your indicator to a chart
2. Press **Ctrl+D** (Data Window)
3. Find buffers with signal values:
   - Buy buffer: Shows non-zero when buy signal appears
   - Sell buffer: Shows non-zero when sell signal appears

### 4. Configure EA
1. Attach EA to same chart as indicator
2. Set these parameters:
   ```
   IndicatorName = "YourIndicator.ex4"
   BuyBufferNumber = 0  (your buy buffer)
   SellBufferNumber = 1 (your sell buffer)
   TelegramBotToken = "your_bot_token"
   TelegramChatID = "your_chat_id"
   EnableDebugMode = true  (for testing)
   ```

### 5. Test & Go Live
1. Wait for signal to appear
2. Check MT4 Experts tab for debug messages
3. Verify Telegram alert arrives
4. Set `EnableDebugMode = false`
5. Enable performance tracking (optional):
   ```
   EnablePerformanceTracking = true
   PerformanceTrackingBars = 20
   TakeProfitPips = 50.0
   StopLossPips = 30.0
   ```
6. Enjoy automated alerts and performance reports!

## 📊 Configuration Cheat Sheet

### Essential Parameters
```
IndicatorName: Exact .ex4 filename (case-sensitive)
BuyBufferNumber: 0-7 (typically 0 or 1)
SellBufferNumber: 0-7 (typically 1 or 2)
TelegramBotToken: Your bot token from BotFather
TelegramChatID: Your chat ID (numeric)
```

### Recommended Settings
```
SignalTiming: ENTRY_SAME_CANDLE (most common)
UseCurrentTimeframe: true (use chart timeframe)
DuplicatePreventionBars: 5 (prevents alert spam)
EnableDebugMode: true (for testing, then false)
SendPopupAlert: true (good for verification)
EnableTelegramAlerts: true (main alert method)
```

## 🔍 Finding Buffer Numbers

### Method 1: Data Window (Fastest)
1. Attach indicator to chart
2. Press **Ctrl+D**
3. Look for your indicator
4. Identify buffers with changing values

### Method 2: Debug Logging
1. Set `EnableDebugMode = true`
2. Set any buffer numbers (e.g., 0 and 1)
3. Check Experts tab for signal detection
4. Adjust buffer numbers until signals appear

### Common Buffer Patterns
```
Buffer 0: Buy signals (most common)
Buffer 1: Sell signals (most common)
Buffer 2+: Additional data or unused
```

## 📱 Telegram Setup

### Get Bot Token
1. Open Telegram
2. Search `@BotFather`
3. Send `/newbot`
4. Follow instructions
5. Copy token: `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`

### Get Chat ID
1. Send message to your bot
2. Visit: `https://api.telegram.org/botYOUR_TOKEN/getUpdates`
3. Find `"chat":{"id":-123456789`
4. Copy the number: `-123456789`

## ⚡ Troubleshooting Quick Fixes

### No Signals Detected
- ✅ Check indicator name (exact filename)
- ✅ Verify buffer numbers (Ctrl+D)
- ✅ Enable debug mode
- ✅ Check Experts tab for errors

### Telegram Not Working
- ✅ Verify bot token
- ✅ Check chat ID
- ✅ Test bot manually in Telegram
- ✅ Check internet connection

### EA Not Running
- ✅ Enable AutoTrading (button in toolbar)
- ✅ Allow DLL imports in EA properties
- ✅ Check compilation errors

## 🎯 Pro Tips

1. **Start with debug mode** to see what's happening
2. **Use popup alerts** to verify signals before Telegram
3. **Test during active market hours** for real signals
4. **Monitor Experts tab** for error messages
5. **Start with small duplicate prevention** (3-5 bars) then adjust

## 📈 Example Alert Message

```
🔔 TRADING SIGNAL

📊 Asset: EURUSD
⏱️ Timeframe: H1
🎯 Signal: BUY
💰 Price: 1.0850
⌚ Time: 2026-01-15 14:30:00

From: MyPriceAction.ex4
```

## 🚀 Ready to Trade!

Once you see alerts coming through:
1. Disable debug mode
2. Adjust duplicate prevention as needed
3. Monitor first few signals manually
4. Enjoy automated trading alerts!

**Remember**: Always verify signals before trading. The EA sends alerts but doesn't execute trades.
