# Setup Checklist

Use this checklist to ensure your MT4 Telegram Alert Indicator is properly configured.

## 📋 Pre-Installation Checklist

### System Requirements
- [ ] Windows 7 or higher
- [ ] MetaTrader 4 installed (Build 1090+)
- [ ] Active internet connection (minimum 1 Mbps)
- [ ] Telegram app installed (mobile or desktop)

### Verify MT4 Version
```
1. Open MT4
2. Click Help → About
3. Check build number (should be 1090 or higher)
4. If older, click "Check for updates"
```

---

## 📱 Telegram Bot Setup Checklist

### Step 1: Create Bot
- [ ] Opened Telegram app
- [ ] Found @BotFather (verified blue checkmark)
- [ ] Sent `/newbot` command
- [ ] Chose bot name (e.g., "My Trading Alerts")
- [ ] Chose username (must end with 'bot')
- [ ] **Received bot token** (saved securely)

### Step 2: Verify Bot Token Format
- [ ] Token contains colon `:` character
- [ ] Token format: `[numbers]:[letters/numbers]`
- [ ] Example: `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`
- [ ] No spaces at beginning or end

### Step 3: Get Chat ID
- [ ] Found bot in Telegram search
- [ ] Clicked **Start** button
- [ ] Sent test message to bot
- [ ] Opened browser
- [ ] Visited: `https://api.telegram.org/bot[TOKEN]/getUpdates`
- [ ] Replaced `[TOKEN]` with actual bot token
- [ ] Found `"chat":{"id":` in JSON response
- [ ] **Saved chat ID** (number after "id")

### Step 4: Verify Chat ID Format
- [ ] Personal chat: Positive number (e.g., `123456789`)
- [ ] Group chat: Negative number (e.g., `-123456789`)
- [ ] No quotes around the number
- [ ] No spaces at beginning or end

### Step 5: Test Telegram API
- [ ] Opened browser
- [ ] Visited test URL:
  ```
  https://api.telegram.org/bot[TOKEN]/sendMessage?chat_id=[CHAT_ID]&text=Test
  ```
- [ ] Replaced `[TOKEN]` and `[CHAT_ID]` with actual values
- [ ] Received "Test" message in Telegram
- [ ] Browser showed: `{"ok":true,...}`

✅ **If test message received**: Telegram setup complete!
❌ **If test failed**: Check token and chat ID, verify bot was started

---

## 🖥️ MT4 Installation Checklist

### Step 1: Locate Data Folder
- [ ] Opened MT4
- [ ] Clicked `File` → `Open Data Folder` (or `Ctrl+Shift+D`)
- [ ] Data folder opened in Windows Explorer

### Step 2: Copy Indicator File
- [ ] Navigated to `MQL4` → `Indicators` folder
- [ ] Copied `TelegramAlertIndicator.mq4` to this folder
- [ ] Verified file appears in folder

### Step 3: Compile Indicator
- [ ] Opened MetaEditor (pressed `F4` in MT4)
- [ ] Found indicator in Navigator: `Indicators` → `TelegramAlertIndicator.mq4`
- [ ] Double-clicked to open file
- [ ] Pressed `F7` to compile
- [ ] Checked compilation results:
  - [ ] Shows: `0 error(s), 0 warning(s)`
  - [ ] If errors: See TROUBLESHOOTING.md

### Step 4: Refresh MT4
- [ ] Closed MetaEditor
- [ ] In MT4, pressed `Ctrl+N` (opens Navigator)
- [ ] Right-clicked in Navigator → `Refresh`
- [ ] Expanded: `Indicators` → `Custom`
- [ ] **Verified**: `TelegramAlertIndicator` appears in list

✅ **If indicator appears in Navigator**: Installation complete!
❌ **If indicator missing**: Check file location and compilation errors

---

## ⚙️ Configuration Checklist

### Step 1: Attach Indicator to Chart
- [ ] Opened chart (any pair, any timeframe)
- [ ] Opened Navigator (`Ctrl+N`)
- [ ] Expanded: `Indicators` → `Custom`
- [ ] Dragged `TelegramAlertIndicator` onto chart
- [ ] Settings dialog appeared

### Step 2: Configure Telegram Settings
```
========== Telegram Settings ==========
```
- [ ] `TelegramBotToken` = [Your bot token]
  - [ ] No quotes added
  - [ ] No spaces at start/end
  - [ ] Complete token copied
- [ ] `TelegramChatID` = [Your chat ID]
  - [ ] No quotes added
  - [ ] No spaces at start/end
  - [ ] Correct positive/negative format
- [ ] `EnableTelegramAlerts` = `true`
- [ ] `MaxRetries` = `3`
- [ ] `RetryDelayMS` = `2000`

### Step 3: Configure Signal Settings
```
========== Signal Settings ==========
```
- [ ] `FastMA_Period` = `10` (or your choice)
- [ ] `SlowMA_Period` = `30` (or your choice)
- [ ] Verified: Fast < Slow
- [ ] `MA_Method` = `Simple` (or your choice)
- [ ] `MA_Price` = `Close`
- [ ] `EnableBuySignals` = `true`
- [ ] `EnableSellSignals` = `true`

### Step 4: Configure Alert Settings
```
========== Alert Settings ==========
```
- [ ] `ShowArrowsOnChart` = `true`
- [ ] `SendPopupAlert` = `true`
- [ ] `SendEmailAlert` = `false` (or `true` if email configured)
- [ ] `PlaySoundAlert` = `true`
- [ ] `AlertSoundFile` = `"alert.wav"`

### Step 5: Configure Advanced Settings
```
========== Advanced Settings ==========
```
- [ ] `MinBarsBetweenSignals` = `5`
- [ ] `AlertOnlyOnNewBar` = `true` (recommended)
- [ ] `EnableDebugMode` = `true` (for first test)

### Step 6: Apply Settings
- [ ] Clicked **OK** button
- [ ] Indicator loaded on chart
- [ ] Indicator name visible at top of chart

✅ **If indicator name shows at top**: Configuration saved!
❌ **If warning appears**: Check error message and fix issues

---

## 🧪 Testing Checklist

### Step 1: Verify Indicator Loaded
- [ ] Indicator name appears at top of chart
- [ ] No error alerts appeared
- [ ] Chart still functioning normally

### Step 2: Check Terminal Logs
- [ ] Opened Terminal panel (`Ctrl+T`)
- [ ] Clicked `Experts` tab
- [ ] Found initialization message:
  ```
  Telegram Alert Indicator initialized successfully
  ```
- [ ] No error messages visible

### Step 3: Check for Historical Signals
- [ ] Scrolled back on chart to view history
- [ ] Looked for signal arrows:
  - [ ] Green arrows below candles (buy signals)
  - [ ] Red arrows above candles (sell signals)
- [ ] If no arrows: Normal if no crossovers occurred

### Step 4: Quick Test (Generate Test Signal)
For immediate testing only:
- [ ] Right-clicked chart → `Indicators List`
- [ ] Selected indicator → `Edit`
- [ ] Changed to test settings:
  - [ ] `FastMA_Period` = `3`
  - [ ] `SlowMA_Period` = `5`
  - [ ] `MinBarsBetweenSignals` = `1`
  - [ ] `AlertOnlyOnNewBar` = `false`
  - [ ] `EnableDebugMode` = `true`
- [ ] Changed chart to `M1` timeframe
- [ ] Clicked **OK**
- [ ] Waited 1-2 minutes

### Step 5: Verify Test Alert
- [ ] Received Telegram message
- [ ] Message contains:
  - [ ] Signal type (BUY or SELL)
  - [ ] Currency pair
  - [ ] Timeframe
  - [ ] Price
  - [ ] Indicator name
  - [ ] Timestamp
- [ ] MT4 popup appeared (if enabled)
- [ ] Sound played (if enabled)

✅ **If test alert received**: System working perfectly!
❌ **If no alert**: Check troubleshooting section below

### Step 6: Return to Production Settings
After successful test:
- [ ] Edited indicator settings
- [ ] Changed back to normal values:
  - [ ] `FastMA_Period` = `10`
  - [ ] `SlowMA_Period` = `30`
  - [ ] `MinBarsBetweenSignals` = `5`
  - [ ] `AlertOnlyOnNewBar` = `true`
  - [ ] `EnableDebugMode` = `false`
- [ ] Changed to production timeframe (H1 or H4)
- [ ] Clicked **OK**

✅ **All tests passed**: Ready for live trading monitoring!

---

## 🔒 Security Checklist

### Bot Token Security
- [ ] Token saved in secure location (password manager)
- [ ] Not shared publicly
- [ ] Not visible in screenshots
- [ ] Preset files secured (Read-only if needed)

### Bot Access Control
- [ ] Bot only in intended chats/groups
- [ ] Bot admin rights reviewed (for groups)
- [ ] No unauthorized users added to groups

### MT4 Security
- [ ] MT4 allowed through firewall only
- [ ] No suspicious indicators/EAs installed
- [ ] Regular antivirus scans performed

---

## 📊 Production Readiness Checklist

### Before Live Use
- [ ] Tested successfully on demo account
- [ ] Observed signals for at least 1 week
- [ ] Verified signal quality meets expectations
- [ ] Adjusted settings based on testing
- [ ] Documented personal optimal settings
- [ ] Created template for easy replication
- [ ] Saved workspace/profile

### Risk Management
- [ ] Trading plan documented
- [ ] Position sizing calculated
- [ ] Stop loss strategy defined
- [ ] Risk-per-trade determined
- [ ] Maximum daily loss limit set

### Alert Management
- [ ] Alert settings comfortable (not too many/few)
- [ ] Sound levels appropriate
- [ ] Telegram notifications enabled on phone
- [ ] Email working (if configured)

### Backup and Recovery
- [ ] Indicator file backed up
- [ ] Settings saved as preset
- [ ] Bot token securely stored
- [ ] Chat ID documented
- [ ] Template saved

---

## 🔄 Regular Maintenance Checklist (Weekly)

### Every Week
- [ ] Check MT4 terminal logs for errors
- [ ] Verify alerts still being received
- [ ] Review signal quality/accuracy
- [ ] Adjust settings if needed
- [ ] Check for MT4 updates

### Every Month
- [ ] Review overall performance
- [ ] Optimize MA periods if needed
- [ ] Update documentation with learnings
- [ ] Test backup/recovery procedure

---

## ❌ Troubleshooting Quick Checklist

### If No Alerts Received
- [ ] Bot token correct?
- [ ] Chat ID correct?
- [ ] Bot started in Telegram?
- [ ] Internet connection active?
- [ ] MT4 allowed through firewall?
- [ ] Debug mode enabled?
- [ ] Check terminal logs for errors

### If Indicator Not Working
- [ ] File in correct folder?
- [ ] Compiled successfully?
- [ ] Navigator refreshed?
- [ ] MT4 restarted?
- [ ] Fast < Slow MA periods?
- [ ] Signals enabled?

### If Too Many/Few Signals
- [ ] MA periods adjusted?
- [ ] MinBarsBetweenSignals correct?
- [ ] Timeframe appropriate?
- [ ] AlertOnlyOnNewBar enabled?

For detailed troubleshooting, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

## ✅ Final Verification

Complete this final check before considering setup done:

- [ ] ✅ Telegram bot created and token obtained
- [ ] ✅ Chat ID obtained and verified
- [ ] ✅ Indicator installed in MT4
- [ ] ✅ Indicator compiled without errors
- [ ] ✅ Indicator configured with credentials
- [ ] ✅ Test alert received successfully
- [ ] ✅ Settings adjusted to production values
- [ ] ✅ Security measures implemented
- [ ] ✅ Documentation reviewed
- [ ] ✅ Backup created

---

## 📚 Next Steps

After completing this checklist:

1. **Read the documentation**:
   - [README.md](README.md) - Complete guide
   - [EXAMPLES.md](EXAMPLES.md) - Strategy examples
   - [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Problem solving

2. **Practice**:
   - Monitor signals for 1-2 weeks
   - Adjust settings to your style
   - Document what works for you

3. **Optimize**:
   - Test different MA periods
   - Try different timeframes
   - Experiment with alert settings

---

## 🎉 Congratulations!

If all items are checked, your MT4 Telegram Alert Indicator is properly set up and ready to use!

**Remember**:
- Always verify signals manually
- Use proper risk management
- Trade responsibly
- Never risk more than you can afford to lose

**Happy Trading!** 🚀📊💰

---

**Need Help?** See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) or enable debug mode and check terminal logs.
