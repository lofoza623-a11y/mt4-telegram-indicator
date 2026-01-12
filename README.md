# MT4 Telegram Alert Indicator

A professional MetaTrader 4 (MT4) custom indicator that sends real-time trading signal alerts to Telegram. This indicator detects trading signals based on Moving Average crossovers and instantly notifies you via Telegram, popup alerts, email, and sound notifications.

## 🌟 Features

- ✅ **Real-time Telegram Alerts** - Instant notifications to your Telegram channel/group
- ✅ **Customizable Signal Detection** - MA crossover strategy with configurable parameters
- ✅ **Multiple Alert Methods** - Telegram, MT4 popup, email, and sound alerts
- ✅ **Duplicate Prevention** - Smart logic to prevent signal spam
- ✅ **Error Handling & Retry Logic** - Automatic retry on API failures
- ✅ **Multi-Timeframe Support** - Works on any chart timeframe
- ✅ **Visual Signals** - Buy/Sell arrows displayed on chart
- ✅ **Lightweight & Efficient** - Minimal resource usage
- ✅ **Fully Customizable** - All parameters configurable via MT4 interface

## 📋 Requirements

- MetaTrader 4 (MT4 Classic)
- Active internet connection
- Telegram account and bot token (see setup instructions below)

## 🚀 Quick Start Guide

### Step 1: Create a Telegram Bot

1. **Open Telegram** and search for `@BotFather`
2. **Start a chat** with BotFather
3. **Send command**: `/newbot`
4. **Choose a name** for your bot (e.g., "My Trading Alerts")
5. **Choose a username** for your bot (must end with 'bot', e.g., "my_trading_alerts_bot")
6. **Copy the Bot Token** - You'll receive a token like: `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`

### Step 2: Get Your Chat ID

#### Option A: Personal Chat (Recommended for individual traders)
1. **Search** for your newly created bot in Telegram
2. **Start a chat** and send any message (e.g., "Hello")
3. **Open browser** and visit:
   ```
   https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates
   ```
   Replace `<YOUR_BOT_TOKEN>` with your actual bot token
4. **Find the Chat ID** in the JSON response under `"chat":{"id":123456789}`
5. **Copy the Chat ID** (it will be a number like `123456789`)

#### Option B: Group/Channel
1. **Create a group** or **channel** in Telegram
2. **Add your bot** as an administrator
3. **Send a message** in the group/channel
4. **Visit** the getUpdates URL (same as above)
5. **Copy the Chat ID** (for groups, it starts with `-`, e.g., `-123456789`)

### Step 3: Install the Indicator in MT4

1. **Open MT4** MetaTrader 4 terminal
2. **Open Data Folder**:
   - Click `File` → `Open Data Folder`
   - Or press `Ctrl + Shift + D`
3. **Navigate** to the `MQL4` → `Indicators` folder
4. **Copy** the `TelegramAlertIndicator.mq4` file into this folder
5. **Restart MT4** or right-click in Navigator and select `Refresh`

### Step 4: Compile the Indicator

1. **Open MetaEditor**: Press `F4` in MT4 or click `Tools` → `MetaQuotes Language Editor`
2. **Open the indicator**: Navigate to `Indicators` → `TelegramAlertIndicator.mq4`
3. **Compile**: Press `F7` or click the `Compile` button
4. **Check for errors**: The compilation log should show "0 error(s), 0 warning(s)"
5. **Close MetaEditor**

### Step 5: Configure the Indicator

1. **Open a chart** in MT4 (any currency pair, any timeframe)
2. **Add the indicator**:
   - Open `Navigator` panel (`Ctrl + N`)
   - Expand `Indicators` → `Custom`
   - **Drag and drop** `TelegramAlertIndicator` onto the chart
3. **Configure settings** in the popup window:

#### Telegram Settings
```
TelegramBotToken = "123456789:ABCdefGHIjklMNOpqrsTUVwxyz"  // Your bot token
TelegramChatID = "123456789"                                 // Your chat ID
EnableTelegramAlerts = true                                  // Enable alerts
MaxRetries = 3                                               // Retry attempts
RetryDelayMS = 2000                                          // Delay between retries
```

#### Signal Settings
```
FastMA_Period = 10          // Fast Moving Average period
SlowMA_Period = 30          // Slow Moving Average period
MA_Method = Simple          // MA calculation method (Simple, Exponential, etc.)
MA_Price = Close            // Price to use (Close, Open, High, Low, etc.)
EnableBuySignals = true     // Enable buy signal alerts
EnableSellSignals = true    // Enable sell signal alerts
```

#### Alert Settings
```
ShowArrowsOnChart = true    // Display signal arrows on chart
SendPopupAlert = true       // Show MT4 popup alerts
SendEmailAlert = false      // Send email (requires MT4 email setup)
PlaySoundAlert = true       // Play sound on signal
AlertSoundFile = "alert.wav" // Sound file name
```

#### Advanced Settings
```
MinBarsBetweenSignals = 5   // Minimum bars between duplicate signals
AlertOnlyOnNewBar = true    // Alert only when new bar forms (prevents repainting)
EnableDebugMode = false     // Enable debug logging in MT4 terminal
```

4. **Click OK** to apply settings

### Step 6: Test the Setup

1. **Check the chart** - You should see the indicator name at the top
2. **Wait for a signal** - Buy arrows appear below candles, Sell arrows above
3. **Verify Telegram** - When a signal triggers, check your Telegram for the alert
4. **Check MT4 Terminal**: 
   - Open `Terminal` panel (`Ctrl + T`)
   - Go to `Experts` tab
   - Look for log messages from the indicator

## 📊 Signal Detection Logic

The indicator uses a **Moving Average Crossover** strategy:

### Buy Signal (Bullish)
- Triggers when the **Fast MA crosses above** the Slow MA
- Green arrow displayed below the candle
- Indicates potential upward momentum

### Sell Signal (Bearish)
- Triggers when the **Fast MA crosses below** the Slow MA
- Red arrow displayed above the candle
- Indicates potential downward momentum

### Duplicate Prevention
- Signals are only sent **once per confirmed crossover**
- `MinBarsBetweenSignals` parameter prevents signal spam
- `AlertOnlyOnNewBar` ensures signals are confirmed (prevents repainting)

## 📱 Telegram Alert Format

When a signal is triggered, you'll receive a message like this:

```
🚨 TRADING SIGNAL ALERT 🚨

Signal: BUY
Pair: EURUSD
Timeframe: H1
Price: 1.08547
Indicator: MA Crossover (10/30)
Time: 2024.01.15 14:30

⚠️ Always verify signals before trading!
```

## ⚙️ Customization Guide

### Changing Signal Logic

The current implementation uses MA crossovers, but you can customize it:

1. **Open MetaEditor** (`F4` in MT4)
2. **Open** `TelegramAlertIndicator.mq4`
3. **Locate** the `OnCalculate()` function
4. **Modify** the signal detection conditions:

```mql4
// Example: Add RSI filter
double rsi = iRSI(NULL, 0, 14, PRICE_CLOSE, i);

// Buy signal with RSI confirmation
if(EnableBuySignals && 
   fastMA_previous <= slowMA_previous && 
   fastMA_current > slowMA_current &&
   rsi < 50)  // Additional RSI filter
{
   // Signal triggered
}
```

5. **Save** and **recompile** (`F7`)
6. **Reload** the indicator on your chart

### Using Different Indicators

You can replace MA crossover with other indicators:

- **RSI**: `iRSI(NULL, 0, 14, PRICE_CLOSE, i)`
- **MACD**: `iMACD(NULL, 0, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, i)`
- **Stochastic**: `iStochastic(NULL, 0, 5, 3, 3, MODE_SMA, 0, MODE_MAIN, i)`
- **Bollinger Bands**: `iBands(NULL, 0, 20, 2, 0, PRICE_CLOSE, MODE_UPPER, i)`
- **Custom conditions**: Combine multiple indicators

### Example Configurations

#### Scalping (Fast Signals)
```
FastMA_Period = 5
SlowMA_Period = 15
MinBarsBetweenSignals = 3
AlertOnlyOnNewBar = true
```

#### Swing Trading (Slower Signals)
```
FastMA_Period = 20
SlowMA_Period = 50
MinBarsBetweenSignals = 10
AlertOnlyOnNewBar = true
```

#### Day Trading
```
FastMA_Period = 10
SlowMA_Period = 30
MinBarsBetweenSignals = 5
AlertOnlyOnNewBar = true
```

## 🔧 Troubleshooting

### Problem: No alerts received on Telegram

**Solutions:**
1. **Verify Bot Token**: Make sure you copied the complete token from BotFather
2. **Verify Chat ID**: Double-check your chat ID from the getUpdates URL
3. **Start the bot**: Send any message to your bot first
4. **Check internet**: Ensure MT4 has internet access
5. **Check terminal logs**: Open MT4 Terminal (`Ctrl + T`) → `Experts` tab
6. **Enable debug mode**: Set `EnableDebugMode = true` for detailed logs

### Problem: Bot token or Chat ID error

**Error message**: "WARNING: Telegram alerts enabled but Bot Token or Chat ID is empty!"

**Solution:**
- Open indicator settings (right-click chart → `Indicators List` → select indicator → `Edit`)
- Enter your Bot Token and Chat ID
- Make sure there are no extra spaces or quotes

### Problem: Signals not appearing on chart

**Solutions:**
1. **Check timeframe**: Make sure you have enough historical data
2. **Adjust MA periods**: Lower periods = more signals, higher periods = fewer signals
3. **Check signal settings**: Ensure `EnableBuySignals` and `EnableSellSignals` are `true`
4. **Wait for crossover**: Signals only appear when MA lines cross

### Problem: Too many duplicate alerts

**Solutions:**
1. **Increase `MinBarsBetweenSignals`**: Set to higher value (e.g., 10)
2. **Enable `AlertOnlyOnNewBar`**: Set to `true` to prevent repainting
3. **Adjust MA periods**: Use higher values for less frequent signals

### Problem: Indicator not showing in MT4

**Solutions:**
1. **Check file location**: Must be in `MT4_Data_Folder/MQL4/Indicators/`
2. **Compile the indicator**: Open in MetaEditor and press `F7`
3. **Fix compilation errors**: Check for errors in the `Errors` tab
4. **Restart MT4**: Close and reopen MetaTrader 4
5. **Refresh Navigator**: Right-click in Navigator → `Refresh`

### Problem: "InternetOpenW failed" error

**Solutions:**
1. **Check firewall**: Allow MT4 to access the internet
2. **Antivirus**: Temporarily disable or whitelist MT4
3. **VPN/Proxy**: May interfere with API requests
4. **Telegram blocked**: If Telegram is blocked in your country, use a VPN

### Problem: Alerts delay or not real-time

**Solutions:**
1. **Check internet speed**: Slow connection causes delays
2. **Reduce `RetryDelayMS`**: Lower value = faster retries (but more resource usage)
3. **Check MT4 performance**: Close unused charts to free resources
4. **Server issues**: Telegram API may have temporary outages

## 📝 Understanding the Code

### Key Functions

#### `OnInit()`
- Initializes indicator buffers and settings
- Validates input parameters
- Sets up chart display properties

#### `OnCalculate()`
- Main calculation loop (runs on every tick)
- Detects MA crossovers
- Triggers alerts when signals are confirmed

#### `SendAlert()`
- Handles all alert types (Telegram, popup, email, sound)
- Prevents duplicate alerts
- Formats alert messages

#### `SendTelegramMessage()`
- Sends HTTP requests to Telegram Bot API
- Implements retry logic for reliability
- Handles API errors

#### `HttpRequest()`
- Uses Windows API (WinINet) for HTTP communication
- Reads API responses
- Returns success/failure status

#### `UrlEncode()`
- Encodes special characters for URL transmission
- Handles UTF-8 characters properly

### Indicator Buffers

- `BuySignalBuffer[]` - Stores buy signal arrow positions
- `SellSignalBuffer[]` - Stores sell signal arrow positions

### Signal Confirmation

The indicator uses several mechanisms to ensure reliable signals:

1. **Crossover Detection**: Compares current and previous bar values
2. **Bar Tracking**: Prevents duplicate alerts on the same bar
3. **Minimum Bar Spacing**: Ensures signals are spaced apart
4. **New Bar Confirmation**: Only alerts when a new bar forms (if enabled)

## 🔒 Security Best Practices

1. **Keep Bot Token Private**: Never share your bot token publicly
2. **Use Private Chat**: For personal trading, use personal chat ID (not public groups)
3. **Restrict Bot Access**: Don't add bot to unknown groups
4. **Revoke Compromised Tokens**: If token is leaked, create a new bot via BotFather
5. **Regular Monitoring**: Check bot activity via BotFather commands

## 📈 Performance Optimization

- **Lightweight Design**: Minimal CPU and memory usage
- **Efficient Calculations**: Only calculates when necessary
- **Smart Buffering**: Uses MT4's native buffer system
- **Conditional Alerts**: Only sends alerts when conditions are met
- **Retry Logic**: Prevents resource waste on failed requests

## 🛠️ Advanced Usage

### Running on Multiple Charts

You can run the indicator on multiple charts simultaneously:

1. Each chart operates independently
2. Alerts will specify the currency pair and timeframe
3. Use different MA settings for different strategies
4. Consider separate chat IDs for different pairs (requires multiple bots)

### Integration with Expert Advisors (EA)

The indicator can work alongside EAs:

1. Visual signals help confirm EA decisions
2. Telegram alerts provide oversight when away from computer
3. Both can use the same signal logic

### Creating Custom Alert Messages

Edit the `SendAlert()` function to customize message format:

```mql4
string alertMessage = StringFormat(
   "🔔 CUSTOM ALERT\n" +
   "Action: %s %s\n" +
   "Entry: %s\n" +
   "SL: %s | TP: %s",
   signalType, symbol, priceStr, stopLoss, takeProfit
);
```

### Multi-Bot Setup

For advanced users managing multiple strategies:

1. Create multiple bots in BotFather
2. Use different tokens for different strategies
3. Send to different chat IDs or groups
4. Organize by timeframe, pair, or strategy type

## 📚 Additional Resources

### MQL4 Documentation
- [MQL4 Reference](https://docs.mql4.com/)
- [Built-in Indicators](https://docs.mql4.com/indicators)
- [Technical Indicators](https://docs.mql4.com/indicators)

### Telegram Bot API
- [Official Documentation](https://core.telegram.org/bots/api)
- [BotFather Commands](https://core.telegram.org/bots#botfather)

### Trading Strategies
- Moving Average Crossovers
- Trend Following Systems
- Support/Resistance Breakouts

## 🤝 Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## ⚠️ Disclaimer

This indicator is provided for educational and informational purposes only. Trading involves substantial risk of loss. Past performance is not indicative of future results. Always:

- Practice on a demo account first
- Use proper risk management
- Never trade with money you can't afford to lose
- Verify all signals manually before placing trades
- Consult with a financial advisor

The authors are not responsible for any trading losses incurred from using this indicator.

## 📄 License

This project is open source and available under the MIT License.

## 💬 Support

If you encounter issues or have questions:

1. Check the Troubleshooting section
2. Enable debug mode and check terminal logs
3. Review the code comments in MetaEditor
4. Test with default settings first
5. Verify Telegram bot setup via BotFather

## 🎯 Version History

### v1.00 (Current)
- Initial release
- MA crossover signal detection
- Telegram integration with retry logic
- Multiple timeframe support
- Customizable parameters
- Comprehensive error handling
- Duplicate prevention system
- Debug mode for troubleshooting

---

**Happy Trading! 📊💰**

Remember: The best indicator is a well-informed trader. Use this tool to enhance your trading, not replace your judgment.
