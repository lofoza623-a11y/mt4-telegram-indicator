# Troubleshooting Guide

Complete guide to resolving common issues with the MT4 Telegram Alert Indicator.

## 🔍 Diagnostic Steps

Before troubleshooting specific issues, follow these diagnostic steps:

### Step 1: Enable Debug Mode
1. Right-click chart → `Indicators List`
2. Select `TelegramAlertIndicator` → `Edit`
3. Set `EnableDebugMode = true`
4. Click `OK`

### Step 2: Check Terminal Logs
1. Open MT4 Terminal panel: `Ctrl + T`
2. Go to `Experts` tab
3. Look for messages from the indicator
4. Note any error messages

### Step 3: Verify Basic Setup
- [ ] Indicator compiled without errors
- [ ] Indicator visible on chart
- [ ] Bot Token entered correctly
- [ ] Chat ID entered correctly
- [ ] Internet connection active
- [ ] MT4 allowed through firewall

---

## 🚨 Common Issues & Solutions

### Issue 1: No Telegram Alerts Received

**Symptom**: Signals appear on chart but no Telegram message

#### Solution A: Verify Bot Token

1. **Check token format**: Should be like `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`
2. **Common mistakes**:
   - Extra spaces at beginning or end
   - Missing parts of the token
   - Copied incorrectly from BotFather
3. **Verify token is active**:
   ```
   Open browser:
   https://api.telegram.org/bot<YOUR_TOKEN>/getMe
   
   Should return:
   {"ok":true,"result":{"id":123456789,"is_bot":true,...}}
   ```
4. **If token invalid**: Create new bot with BotFather

#### Solution B: Verify Chat ID

1. **Check Chat ID format**:
   - Personal chat: `123456789` (positive number)
   - Group chat: `-123456789` (negative number, starts with -)
2. **Get correct Chat ID**:
   ```
   1. Send message to your bot
   2. Visit: https://api.telegram.org/bot<YOUR_TOKEN>/getUpdates
   3. Find "chat":{"id":123456789}
   4. Copy the exact number
   ```
3. **For groups**: Make sure you added the bot as admin

#### Solution C: Start the Bot

**Problem**: Bot won't send messages until you start it

1. Open Telegram
2. Search for your bot
3. Click `Start` button
4. Send any message (e.g., "hello")
5. Try generating a signal again

#### Solution D: Check Internet Connection

1. **Test MT4 internet access**:
   ```
   In MT4, open Tools → Options → Server tab
   Check if connected to broker server
   ```
2. **Test general internet**:
   - Open browser
   - Visit any website
3. **Check firewall**:
   - Allow MT4.exe through Windows Firewall
   - Temporarily disable antivirus to test

#### Solution E: Check MT4 Terminal Logs

1. Open Terminal (`Ctrl + T`) → `Experts` tab
2. Look for these messages:

**Success message**:
```
Telegram message sent successfully: {"ok":true,...}
```

**Error messages**:
```
ERROR: InternetOpenW failed
→ Firewall blocking, internet issue

Failed to send Telegram message
→ API issue, check token/chat ID

{"ok":false,"error_code":404,"description":"Not Found"}
→ Invalid bot token

{"ok":false,"error_code":400,"description":"Bad Request: chat not found"}
→ Invalid chat ID or bot not started
```

---

### Issue 2: "WARNING: Bot Token or Chat ID is empty"

**Symptom**: Warning appears in MT4 alert when indicator loads

#### Solution:

1. **Configure parameters**:
   - Right-click chart → `Indicators List`
   - Select indicator → `Edit`
   - Enter `TelegramBotToken` (full token from BotFather)
   - Enter `TelegramChatID` (number from getUpdates)
   - Click `OK`

2. **Remove quotes**: Don't add quotes around values in MT4 settings

3. **Verify entries**: After clicking OK, edit again to confirm values saved

---

### Issue 3: Indicator Not Appearing on Chart

**Symptom**: Can't find indicator in Navigator or it won't attach to chart

#### Solution A: File Location

1. **Check file is in correct folder**:
   ```
   MT4 → File → Open Data Folder
   Navigate to: MQL4 → Indicators
   Verify: TelegramAlertIndicator.mq4 exists here
   ```

2. **If file is elsewhere**: Move it to Indicators folder

#### Solution B: Compilation

1. **Open MetaEditor**: Press `F4` in MT4
2. **Navigate to indicator**:
   ```
   Navigator panel (left side)
   Indicators folder
   TelegramAlertIndicator.mq4
   ```
3. **Double-click to open**
4. **Compile**: Press `F7` or click Compile button
5. **Check for errors**:
   - Bottom panel shows compilation results
   - Should show: `0 error(s), 0 warning(s)`
   - If errors exist, see "Compilation Errors" section below

#### Solution C: Refresh Navigator

1. In MT4 Navigator panel (`Ctrl + N`)
2. Right-click anywhere in Navigator
3. Select `Refresh`
4. Check Custom Indicators folder

#### Solution D: Restart MT4

1. Close MetaTrader 4 completely
2. Wait 5 seconds
3. Reopen MT4
4. Check Navigator → Indicators → Custom

---

### Issue 4: Compilation Errors

**Symptom**: MetaEditor shows errors when compiling

#### Common Compilation Errors:

**Error: `'InternetOpenW' - function not defined`**

**Solution**:
```
This means WinINet import failed. Fix:

1. Check #import section at top of code
2. Verify all DLL imports are correct
3. Ensure you're using Windows (WinINet is Windows-specific)
4. If on VPS: Install all Windows updates
```

**Error: `'ArraySetAsSeries' - function not defined`**

**Solution**:
```
Old MT4 version. Update MT4:

1. Open MT4
2. Help → About
3. Click "Check for updates"
4. Install latest version
```

**Error: `undeclared identifier`**

**Solution**:
```
Variable name typo or missing declaration:

1. Check line number in error message
2. Verify variable is declared before use
3. Check spelling matches exactly
```

**Error: `wrong parameters count`**

**Solution**:
```
Function called with wrong number of parameters:

1. Find the function call at error line
2. Check MQL4 documentation for correct parameters
3. Match parameter count and types
```

---

### Issue 5: Too Many Duplicate Alerts

**Symptom**: Receiving multiple alerts for the same signal

#### Solution A: Adjust MinBarsBetweenSignals

1. Open indicator settings
2. Increase `MinBarsBetweenSignals` to `10` or higher
3. This forces more spacing between signals

#### Solution B: Enable AlertOnlyOnNewBar

1. Open indicator settings
2. Set `AlertOnlyOnNewBar = true`
3. Signals only trigger when bar is confirmed

#### Solution C: Increase MA Periods

1. Higher MA periods = fewer crossovers
2. Example: Change from `10/30` to `20/50`
3. Reduces signal frequency overall

---

### Issue 6: No Signals Appearing on Chart

**Symptom**: Indicator loaded but no arrows appear

#### Solution A: Check MA Periods

1. **Verify Fast < Slow**: FastMA must be less than SlowMA
2. **Adjust sensitivity**: Lower values = more signals
3. **Suggested starting values**: `10/30`

#### Solution B: Ensure Enough Historical Data

1. **Load more history**:
   ```
   MT4 → Tools → Options → Charts tab
   Max bars in chart: 10000 or higher
   Max bars in history: 50000 or higher
   ```
2. **Scroll back** on chart to load more candles
3. Wait for chart to fully load

#### Solution C: Check Timeframe

1. Some timeframes may not have crossovers yet
2. Try different timeframe: `H1` or `H4` usually has signals
3. Or adjust MA periods for current timeframe

#### Solution D: Verify Signal Settings

1. Check `EnableBuySignals = true`
2. Check `EnableSellSignals = true`
3. Ensure at least one is enabled

---

### Issue 7: "InternetOpenW failed" Error

**Symptom**: Terminal shows "ERROR: InternetOpenW failed"

#### Solution A: Firewall Settings

**Windows Firewall**:
1. Open Windows Security
2. Firewall & network protection
3. Allow an app through firewall
4. Find `terminal.exe` (MT4)
5. Check both Private and Public
6. Click OK

**Third-party Firewall/Antivirus**:
1. Open your antivirus/firewall software
2. Add MT4 to exceptions/whitelist
3. Allow all network access for MT4
4. Restart MT4

#### Solution B: VPN/Proxy Issues

1. **If using VPN**: Try disabling temporarily
2. **If using proxy**: Configure MT4 proxy settings:
   ```
   Tools → Options → Server
   Enable proxy server
   Enter proxy details
   ```

#### Solution C: Windows Updates

1. Some Windows API functions require updates
2. Open Windows Update
3. Install all available updates
4. Restart computer
5. Try again

---

### Issue 8: Signals Appearing on Wrong Candles

**Symptom**: Signal arrows appear on candles that don't show crossover

#### Solution: Enable AlertOnlyOnNewBar

**Problem**: Indicator repainting (recalculating on current bar)

1. Open indicator settings
2. Set `AlertOnlyOnNewBar = true`
3. This ensures signals only on confirmed (closed) bars
4. Arrows will appear on bar `[1]` instead of bar `[0]`

---

### Issue 9: Telegram API Errors

**Symptom**: Specific error codes in terminal logs

#### Error Code 400: Bad Request

```
{"ok":false,"error_code":400,"description":"Bad Request: chat not found"}
```

**Solutions**:
1. Chat ID is incorrect
2. Get correct Chat ID from getUpdates
3. For groups: Must start with `-` (negative number)
4. Bot must be started or added to group first

#### Error Code 401: Unauthorized

```
{"ok":false,"error_code":401,"description":"Unauthorized"}
```

**Solutions**:
1. Bot token is invalid
2. Token was revoked
3. Create new bot with BotFather
4. Copy new token

#### Error Code 404: Not Found

```
{"ok":false,"error_code":404,"description":"Not Found"}
```

**Solutions**:
1. Bot token format is wrong
2. Bot was deleted from BotFather
3. Verify token at: `https://api.telegram.org/bot<TOKEN>/getMe`

#### Error Code 429: Too Many Requests

```
{"ok":false,"error_code":429,"description":"Too Many Requests: retry after X"}
```

**Solutions**:
1. You're sending too many messages
2. Increase `MinBarsBetweenSignals`
3. Increase `RetryDelayMS` to `5000` or higher
4. Wait and try again later

---

### Issue 10: Alerts Delayed or Not Real-Time

**Symptom**: Receiving alerts several minutes after signal appears

#### Solution A: Internet Speed

1. **Test connection speed**: Use speedtest.net
2. **Minimum required**: 1 Mbps upload
3. **If slow**: Contact ISP or switch internet provider

#### Solution B: Reduce RetryDelayMS

1. Open indicator settings
2. Lower `RetryDelayMS` to `1000` (1 second)
3. Balance between speed and reliability

#### Solution C: Check MT4 Performance

1. **Close unnecessary charts**: Each chart uses resources
2. **Remove heavy indicators**: Some indicators lag MT4
3. **Restart MT4**: Fresh start can improve performance
4. **Check CPU usage**: Task Manager → MT4 should use <5% CPU

#### Solution D: Telegram Server Issues

1. Telegram API occasionally has delays (rare)
2. Check Telegram status: https://twitter.com/telegram
3. Wait for Telegram to resolve
4. Usually resolves within minutes

---

### Issue 11: Email Alerts Not Working

**Symptom**: Telegram works but email doesn't send

#### Solution: Configure MT4 Email Settings

1. **Open MT4 email settings**:
   ```
   Tools → Options → Email tab
   ```

2. **Configure SMTP settings**:
   ```
   Enable: ✓ (checked)
   SMTP server: smtp.gmail.com:587 (for Gmail)
   SMTP login: your-email@gmail.com
   SMTP password: your-app-password
   From: your-email@gmail.com
   To: your-email@gmail.com
   ```

3. **For Gmail users**:
   - Enable 2-factor authentication
   - Generate App Password:
     - Google Account → Security
     - App passwords → Generate
     - Use this password (not your regular password)

4. **Test email**:
   - Click `Test` button in Email settings
   - Should receive test email within 1 minute

---

### Issue 12: Indicator Removed After MT4 Restart

**Symptom**: Indicator disappears when reopening MT4

#### Solution A: Save Template

1. **With indicator on chart**:
   ```
   Right-click chart → Template → Save Template
   Name it (e.g., "TradingSetup")
   ```

2. **Load template on new charts**:
   ```
   Right-click chart → Template → Load Template
   Select your saved template
   ```

#### Solution B: Set as Default Template

1. **With indicator configured on chart**:
   ```
   Right-click chart → Template → Save Template
   Name it exactly: default
   ```

2. **All new charts will use this template**

#### Solution C: Save Profile

1. **Save workspace**:
   ```
   File → Profiles → Save Profile As
   Name it (e.g., "MyWorkspace")
   ```

2. **Load on startup**:
   ```
   File → Profiles → Load Profile
   Select your saved profile
   ```

---

### Issue 13: Arrows Not Visible on Chart

**Symptom**: Indicator running but can't see arrows

#### Solution A: Check Display Settings

1. **Verify ShowArrowsOnChart**:
   - Open indicator settings
   - Ensure `ShowArrowsOnChart = true`

2. **Check arrow colors**:
   - Buy arrows: Green/Lime
   - Sell arrows: Red
   - Change if needed: Indicator properties → Colors tab

#### Solution B: Zoom Chart

1. **Arrows may be outside visible area**:
   - Zoom out: Hold `Ctrl` and scroll down
   - Scroll chart back to see historical signals
   - Arrows appear slightly below/above candles

#### Solution C: Check Indicator Loaded

1. **Verify indicator is active**:
   ```
   Right-click chart → Indicators List
   Should show: TelegramAlertIndicator
   ```

2. **If not listed**: Re-attach indicator to chart

---

### Issue 14: Bot Token Visible to Others

**Symptom**: Security concern about token visibility

#### Solution: Use MT4 Preset Files

1. **Save configuration as preset**:
   ```
   In indicator settings dialog
   Click "Save" button (bottom left)
   Name it: "MyTelegramSetup"
   ```

2. **Token saved in preset file**: Located at:
   ```
   MT4_Data_Folder/Presets/TelegramAlertIndicator.set
   ```

3. **File permissions**: Set file to Read-Only
   - Right-click preset file → Properties
   - Check "Read-only"
   - Click OK

4. **Don't share screenshots** showing indicator settings with token

5. **Revoke compromised tokens**:
   - If token leaked, create new bot
   - Revoke old bot via BotFather: `/deletebot`

---

## 🔬 Advanced Diagnostics

### Test Telegram API Manually

**Method 1: Browser Test**
```
1. Open browser
2. Visit: https://api.telegram.org/bot<YOUR_TOKEN>/sendMessage?chat_id=<YOUR_CHAT_ID>&text=Test
3. Should receive "Test" message in Telegram
4. Response should show: {"ok":true,...}
```

**Method 2: Command Line Test (Windows)**
```
1. Open Command Prompt
2. Run: curl "https://api.telegram.org/bot<TOKEN>/sendMessage?chat_id=<CHAT_ID>&text=Test"
3. Check response
```

### Check MT4 Build Version

```
1. Open MT4
2. Help → About
3. Note the build number
4. Minimum recommended: Build 1090+
5. If older: Update MT4
```

### Verify WinINet DLL

```
1. Open Command Prompt as Administrator
2. Run: regsvr32 wininet.dll
3. Should see: "DllRegisterServer in wininet.dll succeeded"
4. If error: Reinstall Windows updates
```

### Debug HTTP Request

Add debug prints in code:

```mql4
// In HttpRequest() function, add:
Print("URL: ", url);
Print("Response: ", response);
Print("hInternet: ", hInternet);
Print("hUrl: ", hUrl);
```

Recompile and check terminal for detailed output.

---

## 📋 Checklist for Complete Setup Verification

Use this checklist to verify everything is configured correctly:

- [ ] MT4 is latest version (Build 1090+)
- [ ] Indicator file in MQL4/Indicators folder
- [ ] Indicator compiled successfully (0 errors)
- [ ] Indicator visible in Navigator → Custom Indicators
- [ ] Indicator attached to chart
- [ ] Indicator name visible at top of chart
- [ ] Bot created via BotFather
- [ ] Bot token saved (format: 123456789:ABC...)
- [ ] Bot started (sent /start command)
- [ ] Chat ID obtained (visited getUpdates URL)
- [ ] Token entered in indicator settings (no extra spaces)
- [ ] Chat ID entered in indicator settings
- [ ] EnableTelegramAlerts = true
- [ ] Internet connection active
- [ ] MT4 allowed through firewall
- [ ] Test message sent successfully (manual API test)
- [ ] MA periods configured (Fast < Slow)
- [ ] Sufficient historical data loaded
- [ ] Debug mode enabled for testing
- [ ] Terminal logs showing no errors

If ALL items checked: Setup is complete and should work.

---

## 🆘 When All Else Fails

If you've tried everything and still have issues:

### Step 1: Complete Reset

1. **Remove indicator from chart**
2. **Delete compiled file**:
   ```
   MT4_Data_Folder/MQL4/Indicators/TelegramAlertIndicator.ex4
   ```
3. **Restart MT4**
4. **Recompile indicator** in MetaEditor
5. **Create new bot** with BotFather
6. **Get new token and chat ID**
7. **Attach indicator** with new credentials

### Step 2: Test Minimal Configuration

Use absolute minimal settings:

```
TelegramBotToken = "YOUR_NEW_TOKEN"
TelegramChatID = "YOUR_NEW_CHAT_ID"
EnableTelegramAlerts = true
MaxRetries = 3
RetryDelayMS = 2000
FastMA_Period = 5
SlowMA_Period = 10
EnableDebugMode = true
```

Test on M1 timeframe for quick signals.

### Step 3: Check System Requirements

- **OS**: Windows 7 or higher
- **MT4**: Build 1090 or higher
- **Internet**: Minimum 1 Mbps
- **.NET Framework**: 4.5 or higher
- **Windows Updates**: All critical updates installed

### Step 4: Alternative Testing

Test if issue is indicator-specific or system-wide:

1. Try a different custom indicator (any)
2. Try MT4 email alerts (Tools → Options → Email)
3. Try MT4 on different computer
4. Try different broker's MT4 platform

---

## 📞 Support Resources

### Official Documentation
- MQL4 Reference: https://docs.mql4.com/
- Telegram Bot API: https://core.telegram.org/bots/api

### Community Help
- MQL4 Forum: https://www.mql5.com/en/forum
- Telegram Bot Support: @BotSupport

### Error Code References
- Telegram API Errors: https://core.telegram.org/bots/api#error-codes
- Windows Error Codes: https://docs.microsoft.com/en-us/windows/win32/debug/system-error-codes

---

## 💡 Prevention Tips

To avoid future issues:

1. **Keep backups**: Save working configurations as presets
2. **Document changes**: Note what settings work best for you
3. **Update regularly**: Keep MT4 and Windows updated
4. **Monitor logs**: Regularly check terminal for warnings
5. **Test before important sessions**: Verify alerts work before big news
6. **Use stable internet**: Wired connection more reliable than WiFi
7. **Maintain organized workspace**: Save profiles and templates
8. **Keep tokens secure**: Never share bot token publicly

---

**Still having issues?** Enable debug mode and check terminal logs for specific error messages. The logs will provide detailed information about what's happening.

Good luck, and happy trading! 📈
