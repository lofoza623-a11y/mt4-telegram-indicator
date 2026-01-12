# Quick Start Guide - 5 Minutes to Trading Alerts

Get your MT4 Telegram alerts up and running in just 5 minutes!

## ⚡ Prerequisites

- MetaTrader 4 installed
- Telegram app on your phone
- 5 minutes of your time

---

## 📱 Step 1: Create Telegram Bot (2 minutes)

### 1.1 Open Telegram and find BotFather
- Open Telegram
- Search: `@BotFather`
- Click to open chat

### 1.2 Create your bot
- Send: `/newbot`
- Choose name: `My Trading Bot`
- Choose username: `mytradingbot123_bot` (must end with 'bot')
- **SAVE THE TOKEN** you receive (looks like: `123456789:ABCdef...`)

### 1.3 Get your Chat ID
- Search for your bot name in Telegram
- Click **Start**
- Send any message (e.g., "hello")
- Open browser and visit:
  ```
  https://api.telegram.org/bot<YOUR_TOKEN>/getUpdates
  ```
  (Replace `<YOUR_TOKEN>` with your actual token)
- Find the number after `"chat":{"id":` (e.g., `123456789`)
- **SAVE THIS CHAT ID**

---

## 🖥️ Step 2: Install Indicator in MT4 (2 minutes)

### 2.1 Open MT4 Data Folder
- Open MetaTrader 4
- Click: `File` → `Open Data Folder` (or press `Ctrl+Shift+D`)

### 2.2 Copy Indicator File
- Navigate to: `MQL4` → `Indicators` folder
- Copy `TelegramAlertIndicator.mq4` into this folder

### 2.3 Compile the Indicator
- In MT4, press `F4` (opens MetaEditor)
- In left panel, find: `Indicators` → `TelegramAlertIndicator.mq4`
- Double-click to open
- Press `F7` to compile
- Check bottom panel: Should show `0 error(s)`
- Close MetaEditor

### 2.4 Refresh MT4
- Back in MT4, press `Ctrl+N` (opens Navigator)
- Right-click in Navigator → `Refresh`

---

## ⚙️ Step 3: Configure & Test (1 minute)

### 3.1 Add to Chart
- Open any chart (e.g., EURUSD, H1 timeframe)
- In Navigator (`Ctrl+N`), expand: `Indicators` → `Custom`
- **Drag** `TelegramAlertIndicator` onto the chart

### 3.2 Enter Your Credentials
Settings window will open. Enter:

```
========== Telegram Settings ==========
TelegramBotToken = YOUR_TOKEN_FROM_STEP_1
TelegramChatID = YOUR_CHAT_ID_FROM_STEP_1
EnableTelegramAlerts = true
MaxRetries = 3
RetryDelayMS = 2000

========== Signal Settings ==========
FastMA_Period = 10
SlowMA_Period = 30
(Leave other settings as default)

========== Alert Settings ==========
ShowArrowsOnChart = true
SendPopupAlert = true
PlaySoundAlert = true
(Leave others as default)

========== Advanced Settings ==========
MinBarsBetweenSignals = 5
AlertOnlyOnNewBar = true
EnableDebugMode = true  ← Set to true for first test
```

Click **OK**

### 3.3 Verify Setup
- Look at chart: Indicator name should appear at top
- Look for any arrows on historical candles
- Open Terminal panel: `Ctrl+T` → `Experts` tab
- Should see: "Telegram Alert Indicator initialized successfully"

---

## ✅ Step 4: Test Alert (Quick Test)

### Option A: Wait for Natural Signal
- Wait for MA crossover to occur naturally
- Can take minutes to hours depending on timeframe

### Option B: Quick Test (Get Signal Now)
For immediate testing:

1. **Remove indicator** from chart
2. **Re-attach** with these test settings:
   ```
   FastMA_Period = 3
   SlowMA_Period = 5
   MinBarsBetweenSignals = 1
   AlertOnlyOnNewBar = false
   EnableDebugMode = true
   ```
3. **Use M1 timeframe** (1 minute chart)
4. **Wait 1-2 minutes** for a crossover
5. **Check Telegram** for alert message!

### Expected Result
You should receive a message like:
```
🚨 TRADING SIGNAL ALERT 🚨

Signal: BUY
Pair: EURUSD
Timeframe: M1
Price: 1.08547
Indicator: MA Crossover (3/5)
Time: 2024.01.15 14:30

⚠️ Always verify signals before trading!
```

---

## 🎯 Step 5: Switch to Production Settings

Once test works, change back to reliable settings:

1. **Edit indicator settings** (Right-click chart → Indicators List → Edit)
2. **Change to production values**:
   ```
   FastMA_Period = 10
   SlowMA_Period = 30
   MinBarsBetweenSignals = 5
   AlertOnlyOnNewBar = true
   EnableDebugMode = false
   ```
3. **Use H1 or H4 timeframe** for day trading
4. **Click OK**

---

## 🚨 Troubleshooting

### ❌ Problem: "WARNING: Bot Token or Chat ID is empty"
**Fix**: Make sure you entered both token and chat ID in settings (no quotes, no spaces)

### ❌ Problem: No Telegram alerts received
**Fix**:
1. Check you clicked **Start** in your bot chat
2. Verify token is correct (test at: `https://api.telegram.org/bot<TOKEN>/getMe`)
3. Verify chat ID is correct (from getUpdates)
4. Check MT4 Terminal → Experts tab for error messages

### ❌ Problem: Indicator not in Navigator
**Fix**:
1. Make sure file is in: `MT4_Data_Folder/MQL4/Indicators/`
2. Open MetaEditor (F4), compile indicator (F7)
3. Refresh Navigator (right-click → Refresh)
4. Restart MT4

### ❌ Problem: No signals appearing
**Fix**:
1. Use lower MA periods for testing (3/5)
2. Use M1 or M5 timeframe
3. Scroll back on chart to see historical signals
4. Check `EnableBuySignals` and `EnableSellSignals` are `true`

---

## 📊 Recommended Settings by Trading Style

### 📈 Scalping (M1-M5)
```
FastMA_Period = 5
SlowMA_Period = 15
MinBarsBetweenSignals = 2-3
Timeframe: M1, M5
Expected Signals: 10-20 per day
```

### 📈 Day Trading (M15-H1)
```
FastMA_Period = 10
SlowMA_Period = 30
MinBarsBetweenSignals = 5
Timeframe: M15, M30, H1
Expected Signals: 3-8 per day
```

### 📈 Swing Trading (H4-D1)
```
FastMA_Period = 20
SlowMA_Period = 50
MinBarsBetweenSignals = 10
Timeframe: H4, D1
Expected Signals: 1-3 per week
```

---

## 🔥 Pro Tips

1. **Start Conservative**: Use H1 timeframe with 10/30 MA settings
2. **Test First**: Use demo account for at least 1 week
3. **Multiple Timeframes**: Add indicator to multiple charts
4. **Save Template**: Right-click chart → Template → Save Template
5. **Disable Debug**: Turn off `EnableDebugMode` after testing

---

## 📱 Next Steps

✅ **Done with setup?** Read these next:
- [README.md](README.md) - Complete documentation
- [EXAMPLES.md](EXAMPLES.md) - Strategy configurations
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Detailed problem solving

✅ **Ready to customize?** Learn about:
- Adjusting signal sensitivity
- Adding custom indicators (RSI, MACD)
- Creating multiple bot setups
- Customizing alert messages

---

## ⏱️ Time Checkpoint

If you followed this guide:
- ✅ Created Telegram bot (2 min)
- ✅ Installed indicator in MT4 (2 min)
- ✅ Configured and tested (1 min)
- ✅ **Total time: 5 minutes!**

---

## 🎉 Congratulations!

You now have real-time trading alerts sent directly to your Telegram! 

**Important Reminders**:
- Always verify signals manually before trading
- Use proper risk management
- Test thoroughly on demo account first
- Never trade with money you can't afford to lose

---

**Need Help?** Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for detailed solutions.

**Happy Trading!** 🚀📊💰
