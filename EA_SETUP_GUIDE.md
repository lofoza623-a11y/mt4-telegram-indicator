# EA-Based Telegram Alert System - Setup Guide

This guide will help you set up the **PriceActionTelegramAlerts.mq4** Expert Advisor to read signals from your compiled .ex4 indicator and send Telegram alerts.

## 🎯 System Overview

```
User's Compiled Indicator (.ex4)
         ↓ (iCustom reads buffers)
Expert Advisor (EA)
         ↓ (detects signals)
Telegram Bot API
         ↓ (sends alerts)
Telegram Chat (you receive alerts)
```

## 📋 Requirements

- **MetaTrader 4** (MT4 Classic)
- **Your compiled indicator** (.ex4 file)
- **Telegram account** and bot token
- **Active internet connection**

## 🚀 Step 1: Prepare Your Indicator

### Identify Buffer Numbers

You need to determine which buffer numbers your indicator uses for BUY and SELL signals:

1. **Attach your indicator** to a chart in MT4
2. **Open the Data Window** (Press `Ctrl+D`)
3. **Look for your indicator** in the list
4. **Identify the buffers** that show signal values:
   - **Buy signals**: Typically buffer 0 or 1 (non-zero values when buy signal appears)
   - **Sell signals**: Typically buffer 1 or 2 (non-zero values when sell signal appears)

**Example Data Window:**
```
Indicator Name
  Buffer 0: 1.0 (when buy signal) or 0.0 (no signal)
  Buffer 1: 1.0 (when sell signal) or 0.0 (no signal)
  Buffer 2: 0.0 (unused)
```

**Common buffer patterns:**
- **Buffer 0**: Buy signals (non-zero = buy)
- **Buffer 1**: Sell signals (non-zero = sell)
- **Buffer 2+**: Additional data or unused

### Note Your Indicator Filename

- The exact filename of your .ex4 file (e.g., `MyPriceAction.ex4`)
- This is case-sensitive!

## 🤖 Step 2: Create Telegram Bot

### Get Bot Token

1. **Open Telegram** and search for `@BotFather`
2. **Start a chat** with BotFather
3. **Send command**: `/newbot`
4. **Choose a name** for your bot (e.g., "My Trading Alerts")
5. **Choose a username** for your bot (must end with 'bot', e.g., "my_trading_alerts_bot")
6. **Copy the Bot Token** - You'll receive a token like: `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`

### Get Your Chat ID

1. **Start a chat** with your new bot
2. **Send any message** to the bot (e.g., "Hello")
3. **Visit this URL** in your browser: `https://api.telegram.org/botYOUR_BOT_TOKEN/getUpdates`
4. **Replace YOUR_BOT_TOKEN** with your actual bot token
5. **Look for "chat":{"id":-123456789** in the response
6. **Copy the numeric ID** (e.g., `-123456789`)

## 📦 Step 3: Install the EA

### Copy Files to MT4

1. **Copy `PriceActionTelegramAlerts.mq4`** to your MT4 `Experts` folder:
   - Typically: `C:\Program Files\MetaTrader 4\MQL4\Experts\`
2. **Copy your compiled indicator** (.ex4 file) to your MT4 `Indicators` folder:
   - Typically: `C:\Program Files\MetaTrader 4\MQL4\Indicators\`

### Attach to Chart

1. **Open MT4** and navigate to the chart you want to monitor
2. **Attach your indicator** to the chart first
3. **Attach the EA** to the same chart:
   - Drag `PriceActionTelegramAlerts.mq4` from Navigator → Expert Advisors
   - Or right-click on the chart → Expert Advisors → Properties

## ⚙️ Step 4: Configure EA Settings

### Basic Configuration

1. **Open EA Properties** (right-click on chart → Expert Advisors → Properties)
2. **Go to Inputs tab**
3. **Configure these essential settings:**

**Telegram Settings:**
- `TelegramBotToken`: Paste your bot token (e.g., `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`)
- `TelegramChatID`: Paste your chat ID (e.g., `-123456789`)
- `EnableTelegramAlerts`: `true` (to enable Telegram alerts)

**Indicator Settings:**
- `IndicatorName`: Exact .ex4 filename (e.g., `MyPriceAction.ex4`)
- `BuyBufferNumber`: Buffer number for buy signals (typically 0 or 1)
- `SellBufferNumber`: Buffer number for sell signals (typically 1 or 2)
- `SignalTiming`: `ENTRY_SAME_CANDLE` (most common)
- `UseCurrentTimeframe`: `true` (use chart timeframe)

**Alert Settings:**
- `SendPopupAlert`: `true` (recommended for testing)
- `PlaySoundAlert`: `true` (optional)
- `SendEmailAlert`: `false` (requires MT4 email setup)

**Advanced Settings:**
- `DuplicatePreventionBars`: `5` (prevents alert spam)
- `EnableDebugMode`: `true` (for initial testing, then set to `false`)

### Example Configuration

```
========== Telegram Settings ==========
TelegramBotToken = "123456789:ABCdefGHIjklMNOpqrsTUVwxyz"
TelegramChatID = "-123456789"
EnableTelegramAlerts = true
MaxRetries = 3
RetryDelayMS = 2000

========== Indicator Settings ==========
IndicatorName = "MyPriceAction.ex4"
BuyBufferNumber = 0
SellBufferNumber = 1
SignalTiming = ENTRY_SAME_CANDLE
UseCurrentTimeframe = true
CustomTimeframe = PERIOD_H1

========== Alert Settings ==========
SendPopupAlert = true
SendEmailAlert = false
PlaySoundAlert = true
AlertSoundFile = "alert.wav"

========== Advanced Settings ==========
DuplicatePreventionBars = 5
EnableDebugMode = true
```

## 🧪 Step 5: Test the Integration

### Enable Debug Mode

1. Set `EnableDebugMode = true`
2. **Check MT4 Experts tab** (View → Toolbox → Experts)
3. **Look for debug messages** showing signal detection

### Verify Signal Detection

1. **Watch your indicator** for a signal to appear
2. **Check MT4 Experts tab** for messages like:
   ```
   Signal detected: BUY | Buffer=0, Value=1.00000, Bar=0, TF=H1
   Alert triggered: BUY | Price: 1.0850
   Telegram alert sent: true
   ```

### Check Telegram Alert

1. **Open Telegram** and check your chat with the bot
2. **Look for a message** like:
   ```
   🔔 TRADING SIGNAL

   📊 Asset: EURUSD
   ⏱️ Timeframe: H1
   🎯 Signal: BUY
   💰 Price: 1.0850
   ⌚ Time: 2026-01-15 14:30:00

   From: MyPriceAction.ex4
   ```

## 🔧 Troubleshooting

### No Signals Detected

1. **Check indicator name**: Must match .ex4 filename exactly (case-sensitive)
2. **Verify buffer numbers**: Use Data Window (Ctrl+D) to confirm
3. **Check signal values**: Ensure your indicator outputs non-zero values for signals
4. **Enable debug mode**: Set `EnableDebugMode = true` for detailed logs

### Telegram Alerts Not Working

1. **Verify bot token**: Ensure it's correct and active
2. **Check chat ID**: Ensure it's the correct numeric ID
3. **Test bot manually**: Send a message to your bot in Telegram
4. **Check internet connection**: MT4 needs internet access
5. **Enable Telegram alerts**: Ensure `EnableTelegramAlerts = true`

### Duplicate Alerts

1. **Increase `DuplicatePreventionBars`**: Try 10 instead of 5
2. **Check signal timing**: Ensure `SignalTiming` matches your indicator logic
3. **Review debug logs**: Look for multiple signal detections

### EA Not Running

1. **Check AutoTrading**: Ensure AutoTrading is enabled (button in toolbar)
2. **Check EA permissions**: Ensure "Allow live trading" and "Allow DLL imports" are enabled
3. **Check compilation**: Ensure EA compiled without errors (check Experts tab)

## 📚 Advanced Configuration

### Custom Timeframes

To use a different timeframe than the chart:
1. Set `UseCurrentTimeframe = false`
2. Set `CustomTimeframe` to your desired timeframe (e.g., `PERIOD_H4`)

### Signal Timing

- **ENTRY_SAME_CANDLE**: Signal triggers on current candle (most common)
- **ENTRY_NEXT_CANDLE**: Signal triggers on next candle open (for confirmation)

### Performance Tracking

The EA includes built-in performance tracking to analyze indicator effectiveness:

1. **Enable Performance Tracking**:
   ```
   EnablePerformanceTracking = true
   PerformanceTrackingBars = 20  // Bars to hold trade for evaluation
   TakeProfitPips = 50.0         // Take profit level in pips
   StopLossPips = 30.0           // Stop loss level in pips
   ```

2. **How it works**:
   - Tracks each signal and simulates holding for `PerformanceTrackingBars`
   - Calculates win/loss based on take profit and stop loss levels
   - Updates statistics (win rate, profit factor, total profit/loss)
   - Sends detailed performance reports via Telegram

3. **Performance metrics include**:
   - Win rate and profit factor
   - Total profit/loss statistics
   - Average win/loss per trade
   - Risk/reward analysis
   - Periodic performance reports

### Multiple Alert Methods

- **Telegram**: Primary alert method (recommended)
- **Popup**: MT4 popup alerts (good for testing)
- **Email**: Requires MT4 email setup
- **Sound**: Plays alert.wav file (customizable)

## 🎓 Best Practices

1. **Start with debug mode**: Enable debug mode for initial testing
2. **Test with popup alerts**: Verify signals before enabling Telegram
3. **Use proper buffer numbers**: Double-check with Data Window
4. **Monitor MT4 logs**: Check Experts tab for errors
5. **Start with small positions**: Always verify signals before trading
6. **Use duplicate prevention**: Prevents alert spam during volatile markets

## 📞 Support

If you encounter issues:
1. **Check this guide** for common problems
2. **Review MT4 Experts tab** for error messages
3. **Enable debug mode** for detailed logging
4. **Verify your indicator** works independently first

## 🔄 Updating

To update to newer versions:
1. **Backup your current EA** (copy the .mq4 file)
2. **Download new version**
3. **Copy to MT4 Experts folder**
4. **Recompile** in MetaEditor
5. **Reattach to chart**

Your settings will be preserved as they're stored in the chart template.

## 📝 Notes

- The EA reads signals using `iCustom()` function
- Buffer values must be non-zero and not EMPTY_VALUE to trigger signals
- Telegram API has rate limits - don't spam alerts
- Always test with demo accounts before live trading
- The EA doesn't execute trades - it only sends alerts
