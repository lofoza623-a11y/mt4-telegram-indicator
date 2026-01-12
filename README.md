# MT4 Multi-Indicator Telegram Alert System

A professional MetaTrader 4 (MT4) custom indicator that sends real-time trading signal alerts to Telegram with support for up to **three external indicators** and advanced confirmation logic. Perfect for traders who want multi-timeframe, multi-indicator signal confirmation with instant notifications.

## 🌟 Key Features

- ✅ **Multi-Indicator Support** - Monitor up to 3 external indicators simultaneously
- ✅ **Flexible Confirmation Logic** - AND, OR, Majority, or Single indicator modes
- ✅ **Independent Timeframes** - Each indicator can use different timeframes
- ✅ **Real-time Telegram Alerts** - Instant notifications showing which indicators triggered
- ✅ **Entry Timing Control** - Choose same candle or next candle entry for each indicator
- ✅ **Custom Buffer Selection** - Configure buy/sell buffer numbers for any indicator
- ✅ **Smart Duplicate Prevention** - No alert spam with intelligent filtering
- ✅ **Multiple Alert Methods** - Telegram, MT4 popup, email, and sound alerts
- ✅ **Error Handling & Retry Logic** - Automatic retry on API failures
- ✅ **Comprehensive Validation** - Built-in checks for configuration errors
- ✅ **Debug Mode** - Detailed logging for troubleshooting
- ✅ **Lightweight & Efficient** - Minimal resource usage

## 📋 Requirements

- MetaTrader 4 (MT4 Classic)
- Active internet connection
- Telegram account and bot token (setup instructions below)
- External indicators you want to monitor (optional - can use built-in MT4 indicators)

## 🎯 What's New in Version 2.0

This version completely replaces the simple MA crossover logic with a powerful multi-indicator system:

- **3 Independent Indicator Slots** - Each with full customization
- **Advanced Confirmation Modes** - Choose how indicators must agree
- **Multi-Timeframe Analysis** - Run indicators on different timeframes
- **Detailed Alert Messages** - See exactly which indicators confirmed the signal
- **Flexible Entry Timing** - Control signal trigger timing per indicator
- **Enhanced Validation** - Comprehensive error checking and user feedback

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
3. **Configure settings** in the popup window

## ⚙️ Configuration Guide

### Telegram Settings
```
TelegramBotToken = "123456789:ABCdefGHIjklMNOpqrsTUVwxyz"  // Your bot token from BotFather
TelegramChatID = "123456789"                                 // Your chat ID
EnableTelegramAlerts = true                                  // Master alert toggle
MaxRetries = 3                                               // API retry attempts
RetryDelayMS = 2000                                          // Delay between retries
```

### Indicator 1 Settings
```
Indicator1_Enable = true                  // Enable this indicator slot
Indicator1_Name = "RSI Divergence"        // Custom display name
Indicator1_BuyBuffer = 0                  // Buffer number for buy signals
Indicator1_SellBuffer = 1                 // Buffer number for sell signals
Indicator1_Timing = Same Candle           // When to trigger (Same/Next Candle)
Indicator1_Timeframe = Current            // Timeframe to analyze (Current/M1/M5/etc.)
```

### Indicator 2 & 3 Settings
Same as Indicator 1, but for the second and third indicator slots. Set `Enable = false` if you don't need them.

### Confirmation Settings
```
ConfirmMode = Single                      // How indicators must agree:
                                          // - Single: Any 1 indicator triggers
                                          // - All: All enabled indicators required
                                          // - Majority: At least 2 indicators
                                          // - Any: Same as Single
```

### Alert Settings
```
ShowArrowsOnChart = true                  // Display arrows on chart
SendPopupAlert = true                     // MT4 popup notifications
SendEmailAlert = false                    // Email alerts (requires MT4 email setup)
PlaySoundAlert = true                     // Sound notification
AlertSoundFile = "alert.wav"              // Sound file to play
```

### Advanced Settings
```
DuplicatePreventionBars = 5               // Minimum bars between duplicate alerts
EnableDebugMode = false                   // Enable detailed logging
```

## 🔍 How to Find Buffer Numbers

Finding the correct buffer numbers is crucial for the indicator to work. Here's how:

### Method 1: Using MetaEditor (Recommended)

1. **Open MetaEditor** in MT4 (`F4`)
2. **Navigate** to the indicator file you want to use
3. **Look for** `SetIndexBuffer()` calls in the code
4. **Identify** which buffer numbers correspond to buy/sell signals

Example from code:
```mql4
SetIndexBuffer(0, UpArrowBuffer);    // Buffer 0 = Buy signals
SetIndexBuffer(1, DownArrowBuffer);  // Buffer 1 = Sell signals
```

### Method 2: Using Data Window

1. **Add the indicator** to a chart in MT4
2. **Open Data Window** (`Ctrl + D`)
3. **Move cursor** over a signal arrow
4. **Check** which buffer shows a value (not EMPTY_VALUE)
5. **Buffer numbers** are listed as "Indicator Name [0]", "Indicator Name [1]", etc.

### Method 3: Trial and Error

1. **Start with buffer 0 for buy, 1 for sell** (most common)
2. **Enable debug mode** in settings
3. **Monitor MT4 Terminal** (`Ctrl + T`) → Experts tab
4. **Adjust buffer numbers** if signals don't match
5. **Test** until signals align correctly

### Common Buffer Patterns

| Indicator Type | Buy Buffer | Sell Buffer |
|----------------|------------|-------------|
| Arrow Indicators | 0 | 1 |
| Signal Line Indicators | 0 | 1 |
| Multi-buffer Indicators | Varies | Varies |
| Custom Indicators | Check code | Check code |

## 🎯 Confirmation Logic Explained

### Single (Any 1 Indicator)
- **Behavior**: Alert triggers when ANY enabled indicator signals
- **Use Case**: Maximum sensitivity, catch all possible signals
- **Example**: If Indicator 1 OR Indicator 2 OR Indicator 3 signals → Alert

### All (All Indicators Required)
- **Behavior**: Alert triggers only when ALL enabled indicators agree
- **Use Case**: Highest confidence, lowest false positives
- **Example**: If Indicator 1 AND Indicator 2 AND Indicator 3 all signal → Alert

### Majority (At least 2 Indicators)
- **Behavior**: Alert triggers when at least 2 indicators agree
- **Use Case**: Balanced approach, good for 2-3 indicator setups
- **Example**: If Indicator 1 + Indicator 2 signal (regardless of Indicator 3) → Alert

### Any (Same as Single)
- **Behavior**: Identical to Single mode
- **Use Case**: Alternative naming for clarity

## 📱 Telegram Alert Format

When a signal is triggered, you'll receive a detailed message like this:

```
🚨 MULTI-INDICATOR TRADING SIGNAL 🚨

📊 Signal: BUY
💱 Pair: EURUSD
⏰ Timeframe: H1
💰 Price: 1.08547
📅 Time: 2024.01.15 14:30

✅ Confirmation: Majority (At least 2)
🎯 Indicators Triggered (2 of 3):
   RSI Divergence, MACD Crossover

⚠️ Always verify signals before trading!
```

## 💡 Example Configurations

### Configuration 1: RSI + Stochastic Confirmation

**Use Case**: Overbought/oversold confirmation

```
Indicator 1:
- Name: "RSI Overbought"
- Buy Buffer: 0
- Sell Buffer: 1
- Timeframe: H1
- Timing: Same Candle

Indicator 2:
- Name: "Stochastic Cross"
- Buy Buffer: 0
- Sell Buffer: 1
- Timeframe: H1
- Timing: Same Candle

Indicator 3: Disabled

Confirmation Mode: All (both must confirm)
```

### Configuration 2: Multi-Timeframe MA Crossover

**Use Case**: Trend confirmation across timeframes

```
Indicator 1:
- Name: "MA Cross H1"
- Buy Buffer: 0
- Sell Buffer: 1
- Timeframe: H1
- Timing: Same Candle

Indicator 2:
- Name: "MA Cross H4"
- Buy Buffer: 0
- Sell Buffer: 1
- Timeframe: H4
- Timing: Same Candle

Indicator 3:
- Name: "MA Cross D1"
- Buy Buffer: 0
- Sell Buffer: 1
- Timeframe: D1
- Timing: Same Candle

Confirmation Mode: Majority (2 of 3 timeframes must agree)
```

### Configuration 3: Scalping with Multiple Signals

**Use Case**: Quick entries with multiple confirmation

```
Indicator 1:
- Name: "Fast RSI"
- Buy Buffer: 0
- Sell Buffer: 1
- Timeframe: M5
- Timing: Next Candle

Indicator 2:
- Name: "Bollinger Touch"
- Buy Buffer: 0
- Sell Buffer: 1
- Timeframe: M5
- Timing: Next Candle

Indicator 3:
- Name: "Volume Spike"
- Buy Buffer: 0
- Sell Buffer: 1
- Timeframe: M5
- Timing: Same Candle

Confirmation Mode: Majority (at least 2 signals)
DuplicatePreventionBars: 3 (allow more frequent signals)
```

### Configuration 4: Conservative Swing Trading

**Use Case**: High-confidence longer-term signals

```
Indicator 1:
- Name: "Trend Filter H4"
- Buy Buffer: 0
- Sell Buffer: 1
- Timeframe: H4
- Timing: Same Candle

Indicator 2:
- Name: "MACD Divergence"
- Buy Buffer: 0
- Sell Buffer: 1
- Timeframe: H4
- Timing: Same Candle

Indicator 3:
- Name: "Support/Resistance"
- Buy Buffer: 0
- Sell Buffer: 1
- Timeframe: D1
- Timing: Same Candle

Confirmation Mode: All (maximum confidence)
DuplicatePreventionBars: 10 (avoid whipsaw)
```

## 🔧 Troubleshooting

### Problem: "No indicators are enabled" warning

**Solution:**
- Enable at least one indicator in the settings
- Set `Indicator1_Enable = true` or enable Indicator 2 or 3

### Problem: No signals detected

**Solutions:**
1. **Check buffer numbers**: Use Data Window to verify correct buffers
2. **Enable debug mode**: See what values indicators are reading
3. **Verify indicator is active**: Check that the external indicator is on the same chart
4. **Check timeframe**: If using custom timeframe, ensure data is available
5. **Wait for signals**: Indicators need actual signal conditions to trigger

### Problem: "Buffer must be between 0-7" error

**Solution:**
- MT4 indicators have maximum 8 buffers (0-7)
- Check the indicator code or documentation for valid buffer numbers
- Use Data Window to identify correct buffer

### Problem: Wrong signals triggering

**Solutions:**
1. **Verify buffer assignment**: Buy and sell buffers might be swapped
2. **Check signal logic**: Some indicators use 0 for no signal, others use EMPTY_VALUE
3. **Inspect indicator values**: Enable debug mode to see actual buffer values
4. **Test with one indicator**: Isolate each indicator to verify correct operation

### Problem: Signals from only one timeframe

**Solution:**
- If using custom timeframes, ensure chart has sufficient history
- Download more historical data: `Tools` → `History Center`
- Check that timeframe data is available for the currency pair

### Problem: Telegram alerts not received

**Solutions:**
1. **Verify Bot Token**: Copy complete token from BotFather (no spaces)
2. **Verify Chat ID**: Double-check from getUpdates URL
3. **Start the bot**: Send any message to your bot first
4. **Check internet**: Ensure MT4 can access Telegram API
5. **Check firewall**: Allow MT4 internet access
6. **Enable debug mode**: Check terminal for error messages

### Problem: Too many duplicate alerts

**Solutions:**
1. **Increase `DuplicatePreventionBars`**: Set to higher value (e.g., 10)
2. **Use "Next Candle" timing**: Reduces premature signals
3. **Increase confirmation requirements**: Use "All" or "Majority" mode
4. **Adjust indicator sensitivity**: Configure the external indicators themselves

### Problem: Alerts delayed

**Solutions:**
1. **Check internet speed**: Slow connection causes delays
2. **Reduce retry delay**: Set `RetryDelayMS` lower (e.g., 1000)
3. **Check MT4 performance**: Close unused charts
4. **Telegram API**: May have temporary delays (rare)

### Problem: Debug mode shows empty values

**Solution:**
- Indicator may use EMPTY_VALUE to indicate no signal
- This is normal - the code checks for both EMPTY_VALUE and 0
- Signals only trigger when buffer has a non-zero, non-empty value

## 📊 Understanding Entry Timing

### Same Candle Entry
- **Behavior**: Signal checked and triggered on current bar (bar 0)
- **Pros**: Immediate alerts, no delay
- **Cons**: May trigger on incomplete candles (can repaint)
- **Best For**: Real-time monitoring, when speed is priority

### Next Candle Entry
- **Behavior**: Signal confirmed on previous bar, alerts on new bar
- **Pros**: Confirmed signals, no repainting
- **Cons**: Slight delay (waits for candle close)
- **Best For**: Conservative trading, avoiding false signals

## 🔒 Security Best Practices

1. **Keep Bot Token Private**: Never share your bot token publicly
2. **Use Private Chat**: For personal trading, use personal chat ID
3. **Don't Share Chat ID**: Keep your chat ID confidential
4. **Restrict Bot Access**: Don't add bot to unknown groups
5. **Revoke Compromised Tokens**: If leaked, create new bot via BotFather
6. **Regular Monitoring**: Check bot activity regularly
7. **Backup Configuration**: Save your indicator settings

## 🎓 Best Practices for Multi-Indicator Trading

### 1. Diversify Indicator Types
- Don't use 3 similar indicators (e.g., all moving averages)
- Mix momentum, trend, and volume indicators
- Example: RSI + MA Crossover + Volume Spike

### 2. Use Appropriate Timeframes
- Lower timeframes (M1-M15) for scalping
- Medium timeframes (M30-H1) for day trading
- Higher timeframes (H4-D1) for swing trading
- Multi-timeframe confirmation increases reliability

### 3. Start with Majority Mode
- Good balance between sensitivity and accuracy
- Reduces false signals while catching valid setups
- Adjust based on results

### 4. Test Configurations
- Use MT4 Strategy Tester to backtest
- Paper trade before going live
- Document which configurations work best

### 5. Monitor and Adjust
- Enable debug mode initially
- Review alert history
- Fine-tune buffer numbers and timing
- Adjust duplicate prevention as needed

### 6. Combine with Risk Management
- Don't blindly trade every signal
- Use proper position sizing
- Set stop losses and take profits
- Verify signals manually for high-stakes trades

## 📈 Performance Optimization

- **Lightweight Design**: Minimal CPU and memory usage
- **Efficient Buffer Reading**: Only checks enabled indicators
- **Smart Caching**: Avoids redundant calculations
- **Conditional Alerts**: Only sends when conditions met
- **Retry Logic**: Prevents resource waste on failed requests

## 🛠️ Advanced Usage

### Running on Multiple Charts

You can run the indicator on multiple charts simultaneously:

1. Each chart operates independently
2. Configure different indicators per chart
3. Use different confirmation modes per chart
4. Alerts specify currency pair and timeframe
5. Consider using different chat IDs for different setups (requires multiple bots)

### Creating Indicator Templates

Save your configurations as templates:

1. Configure indicator settings
2. Right-click chart → `Template` → `Save Template`
3. Name it descriptively (e.g., "RSI_MACD_Scalping")
4. Apply to other charts: `Template` → `Load Template`

### Integration with Expert Advisors

The indicator can work alongside EAs:

1. Visual confirmation of EA decisions
2. Manual override capability
3. Multi-strategy monitoring
4. Telegram oversight when away from computer

## 📚 Additional Resources

### MQL4 Documentation
- [MQL4 Reference](https://docs.mql4.com/)
- [Custom Indicators](https://docs.mql4.com/customind)
- [iCustom Function](https://docs.mql4.com/indicators/icustom)

### Telegram Bot API
- [Official Documentation](https://core.telegram.org/bots/api)
- [BotFather Commands](https://core.telegram.org/bots#botfather)

### Trading Resources
- Practice proper risk management
- Learn about indicator combinations
- Study multi-timeframe analysis
- Understand confirmation logic

## 🤝 Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly on MT4
5. Submit a pull request

## ⚠️ Disclaimer

This indicator is provided for educational and informational purposes only. Trading involves substantial risk of loss. Past performance is not indicative of future results. 

**Always:**
- Practice on a demo account first
- Use proper risk management
- Never trade with money you can't afford to lose
- Verify all signals manually before placing trades
- Consult with a financial advisor
- Understand that automated alerts are tools, not trading advice

The authors are not responsible for any trading losses incurred from using this indicator.

## 📄 License

This project is open source and available under the MIT License.

## 💬 Support

If you encounter issues or have questions:

1. Check this README thoroughly
2. Review the Troubleshooting section
3. Enable debug mode and check MT4 Terminal logs
4. Verify Telegram bot setup
5. Test with single indicator first
6. Check buffer numbers using Data Window

## 🎯 Version History

### v2.00 (Current)
- **Major Update**: Complete rewrite with multi-indicator support
- Up to 3 external indicators with independent configuration
- Advanced confirmation logic (Single, All, Majority, Any)
- Independent timeframe selection per indicator
- Entry timing control (Same/Next Candle)
- Enhanced Telegram alerts showing which indicators triggered
- Comprehensive validation and error handling
- Improved debug logging
- Flexible buffer configuration

### v1.00 (Legacy)
- Initial release with simple MA crossover
- Basic Telegram integration
- Single indicator support

---

**Happy Trading! 📊💰**

Remember: The best indicator is a well-informed trader. Use this tool to enhance your trading decisions, not replace your judgment. Multi-indicator confirmation is powerful, but always combine it with proper analysis and risk management.

## 🔗 Quick Links

- [Configuration Template](CONFIG_TEMPLATE.txt) - Copy-paste ready settings
- [Example Setups](EXAMPLES.md) - Real-world configuration examples
- [Troubleshooting Guide](TROUBLESHOOTING.md) - Detailed problem-solving
- [Quick Start](QUICKSTART.md) - Fast setup guide
- [Setup Checklist](SETUP_CHECKLIST.md) - Step-by-step verification
