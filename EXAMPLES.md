# Example Configurations

This document provides ready-to-use configurations for different trading strategies and scenarios.

## 📊 Strategy-Based Configurations

### 1. Scalping Strategy (M1-M5 Timeframes)

**Goal**: Quick entries and exits with frequent signals

```
=== Telegram Settings ===
TelegramBotToken = "YOUR_BOT_TOKEN"
TelegramChatID = "YOUR_CHAT_ID"
EnableTelegramAlerts = true
MaxRetries = 3
RetryDelayMS = 1000

=== Signal Settings ===
FastMA_Period = 5
SlowMA_Period = 15
MA_Method = Exponential (EMA)
MA_Price = Close
EnableBuySignals = true
EnableSellSignals = true

=== Alert Settings ===
ShowArrowsOnChart = true
SendPopupAlert = true
SendEmailAlert = false
PlaySoundAlert = true
AlertSoundFile = "alert.wav"

=== Advanced Settings ===
MinBarsBetweenSignals = 2
AlertOnlyOnNewBar = true
EnableDebugMode = false
```

**Best For**: Active traders, high-frequency trading
**Timeframes**: M1, M5
**Expected Signals**: 10-20 per day

---

### 2. Day Trading Strategy (M15-H1 Timeframes)

**Goal**: Balanced approach with moderate signal frequency

```
=== Telegram Settings ===
TelegramBotToken = "YOUR_BOT_TOKEN"
TelegramChatID = "YOUR_CHAT_ID"
EnableTelegramAlerts = true
MaxRetries = 3
RetryDelayMS = 2000

=== Signal Settings ===
FastMA_Period = 10
SlowMA_Period = 30
MA_Method = Simple (SMA)
MA_Price = Close
EnableBuySignals = true
EnableSellSignals = true

=== Alert Settings ===
ShowArrowsOnChart = true
SendPopupAlert = true
SendEmailAlert = false
PlaySoundAlert = true
AlertSoundFile = "alert.wav"

=== Advanced Settings ===
MinBarsBetweenSignals = 5
AlertOnlyOnNewBar = true
EnableDebugMode = false
```

**Best For**: Part-time traders, side-by-side monitoring
**Timeframes**: M15, M30, H1
**Expected Signals**: 3-8 per day

---

### 3. Swing Trading Strategy (H4-D1 Timeframes)

**Goal**: Long-term positions with high-quality signals

```
=== Telegram Settings ===
TelegramBotToken = "YOUR_BOT_TOKEN"
TelegramChatID = "YOUR_CHAT_ID"
EnableTelegramAlerts = true
MaxRetries = 3
RetryDelayMS = 2000

=== Signal Settings ===
FastMA_Period = 20
SlowMA_Period = 50
MA_Method = Simple (SMA)
MA_Price = Close
EnableBuySignals = true
EnableSellSignals = true

=== Alert Settings ===
ShowArrowsOnChart = true
SendPopupAlert = true
SendEmailAlert = true  // Enable email for important signals
PlaySoundAlert = true
AlertSoundFile = "alert2.wav"

=== Advanced Settings ===
MinBarsBetweenSignals = 10
AlertOnlyOnNewBar = true
EnableDebugMode = false
```

**Best For**: Long-term investors, low-maintenance trading
**Timeframes**: H4, D1, W1
**Expected Signals**: 1-3 per week

---

### 4. Conservative Trading (Low Risk)

**Goal**: Only high-confidence signals, minimal false positives

```
=== Telegram Settings ===
TelegramBotToken = "YOUR_BOT_TOKEN"
TelegramChatID = "YOUR_CHAT_ID"
EnableTelegramAlerts = true
MaxRetries = 3
RetryDelayMS = 2000

=== Signal Settings ===
FastMA_Period = 50
SlowMA_Period = 200
MA_Method = Exponential (EMA)
MA_Price = Close
EnableBuySignals = true
EnableSellSignals = true

=== Alert Settings ===
ShowArrowsOnChart = true
SendPopupAlert = true
SendEmailAlert = true
PlaySoundAlert = true
AlertSoundFile = "alert.wav"

=== Advanced Settings ===
MinBarsBetweenSignals = 20
AlertOnlyOnNewBar = true
EnableDebugMode = false
```

**Best For**: Risk-averse traders, trend followers
**Timeframes**: H4, D1
**Expected Signals**: 1-2 per month
**Note**: Using 50/200 MA (Golden Cross/Death Cross)

---

### 5. Aggressive Trading (High Risk)

**Goal**: Maximum signal frequency, early entries

```
=== Telegram Settings ===
TelegramBotToken = "YOUR_BOT_TOKEN"
TelegramChatID = "YOUR_CHAT_ID"
EnableTelegramAlerts = true
MaxRetries = 2
RetryDelayMS = 1000

=== Signal Settings ===
FastMA_Period = 3
SlowMA_Period = 10
MA_Method = Exponential (EMA)
MA_Price = Close
EnableBuySignals = true
EnableSellSignals = true

=== Alert Settings ===
ShowArrowsOnChart = true
SendPopupAlert = false  // Disable to reduce noise
SendEmailAlert = false
PlaySoundAlert = false  // Disable to reduce noise
AlertSoundFile = "alert.wav"

=== Advanced Settings ===
MinBarsBetweenSignals = 1
AlertOnlyOnNewBar = false  // Alert immediately
EnableDebugMode = false
```

**Best For**: Experienced traders, high-risk tolerance
**Timeframes**: M1, M5
**Expected Signals**: 30+ per day
**Warning**: High false positive rate, use with caution

---

## 🎯 Pair-Specific Configurations

### Major Pairs (EURUSD, GBPUSD, USDJPY)

```
FastMA_Period = 10
SlowMA_Period = 30
MA_Method = Simple (SMA)
MinBarsBetweenSignals = 5
```

**Reason**: Major pairs are liquid with clear trends

### Exotic Pairs (USDTRY, USDZAR, etc.)

```
FastMA_Period = 20
SlowMA_Period = 50
MA_Method = Exponential (EMA)
MinBarsBetweenSignals = 10
```

**Reason**: More volatility requires wider filters

### Cryptocurrency (if broker supports)

```
FastMA_Period = 5
SlowMA_Period = 20
MA_Method = Exponential (EMA)
MinBarsBetweenSignals = 3
AlertOnlyOnNewBar = true
```

**Reason**: High volatility, 24/7 trading

---

## 🔔 Alert Configuration Scenarios

### Silent Trading (No Distractions)

```
ShowArrowsOnChart = true
SendPopupAlert = false
SendEmailAlert = false
PlaySoundAlert = false
EnableTelegramAlerts = true  // Only Telegram
```

**Use Case**: Trading at work, library, or public places

### Maximum Alerts (Don't Miss Anything)

```
ShowArrowsOnChart = true
SendPopupAlert = true
SendEmailAlert = true
PlaySoundAlert = true
EnableTelegramAlerts = true
```

**Use Case**: Important trading sessions, major news events

### Testing Mode (Verify Setup)

```
EnableTelegramAlerts = true
EnableDebugMode = true
MinBarsBetweenSignals = 1
FastMA_Period = 5
SlowMA_Period = 10
```

**Use Case**: First-time setup, troubleshooting

### Night Trading (Sleep Mode)

```
SendPopupAlert = false
PlaySoundAlert = false
EnableTelegramAlerts = true
SendEmailAlert = true
```

**Use Case**: Monitor markets overnight, check alerts in the morning

---

## 🌍 Multi-Chart Setup Examples

### Scenario 1: Multi-Timeframe Analysis

**Setup**: Same pair, different timeframes

| Chart | Pair    | Timeframe | Fast MA | Slow MA | Purpose           |
|-------|---------|-----------|---------|---------|-------------------|
| 1     | EURUSD  | M15       | 5       | 15      | Entry timing      |
| 2     | EURUSD  | H1        | 10      | 30      | Trend confirmation|
| 3     | EURUSD  | H4        | 20      | 50      | Major trend       |

**Bot Setup**: Use the same bot token and chat ID for all charts

---

### Scenario 2: Multi-Pair Monitoring

**Setup**: Different pairs, same timeframe

| Chart | Pair    | Timeframe | Fast MA | Slow MA | Chat Strategy     |
|-------|---------|-----------|---------|---------|-------------------|
| 1     | EURUSD  | H1        | 10      | 30      | Same chat ID      |
| 2     | GBPUSD  | H1        | 10      | 30      | Same chat ID      |
| 3     | USDJPY  | H1        | 10      | 30      | Same chat ID      |

**Result**: All signals from different pairs in one Telegram chat

---

### Scenario 3: Strategy Diversification

**Setup**: Different strategies with separate bots

| Chart | Pair    | Timeframe | Fast MA | Slow MA | Bot              |
|-------|---------|-----------|---------|---------|------------------|
| 1     | EURUSD  | M15       | 5       | 15      | Bot A (Scalping) |
| 2     | EURUSD  | H4        | 20      | 50      | Bot B (Swing)    |
| 3     | GBPUSD  | M15       | 5       | 15      | Bot A (Scalping) |

**Bot Setup**:
- Bot A Token: Scalping strategy signals → Chat ID 1
- Bot B Token: Swing trading signals → Chat ID 2

**Result**: Organized alerts by strategy type

---

## 📱 Telegram Group Organization

### Setup 1: Personal Trading (Individual Trader)

```
Create: Private chat with your bot
Chat ID: Your personal chat ID
Use: All trading signals in one place
```

### Setup 2: Team Trading (Multiple Traders)

```
Create: Private Telegram group
Add: Your bot as admin
Add: Team members
Chat ID: Group chat ID (starts with -)
Use: Share signals with trading team
```

### Setup 3: Strategy-Based Groups

```
Group 1: "Scalping Signals" → Bot Token 1
Group 2: "Swing Trading Signals" → Bot Token 2
Group 3: "Long-term Signals" → Bot Token 3
```

### Setup 4: Pair-Based Channels

```
Channel 1: "EUR Signals" → EURUSD, EURGBP, EURJPY
Channel 2: "GBP Signals" → GBPUSD, GBPJPY, EURGBP
Channel 3: "USD Signals" → All USD pairs
```

---

## 🧪 Testing Configurations

### Quick Test (Generate Signals Fast)

```
FastMA_Period = 3
SlowMA_Period = 5
MinBarsBetweenSignals = 1
AlertOnlyOnNewBar = false
EnableDebugMode = true
```

**Use**: Verify Telegram connection works
**Timeframe**: M1 (will generate signals quickly)

### Production Test (Real Conditions)

```
FastMA_Period = 10
SlowMA_Period = 30
MinBarsBetweenSignals = 5
AlertOnlyOnNewBar = true
EnableDebugMode = true
```

**Use**: Test with real trading parameters
**Timeframe**: H1 (wait for actual signals)

---

## 🛠️ Custom Modifications Examples

### Example 1: Only Trade During London/NY Session

**Modification**: Add time filter in `OnCalculate()` function

```mql4
// Add after signal detection, before SendAlert()
int currentHour = TimeHour(TimeCurrent());
bool isTradingSession = (currentHour >= 8 && currentHour <= 16); // London/NY overlap

if(isTradingSession)
{
   SendAlert("BUY", close[currentBar], time[currentBar], currentBar);
}
```

### Example 2: Add Stop Loss / Take Profit Levels

**Modification**: Calculate SL/TP in `SendAlert()` function

```mql4
double stopLoss = 0;
double takeProfit = 0;

if(signalType == "BUY")
{
   stopLoss = price - (50 * Point);  // 50 pips SL
   takeProfit = price + (100 * Point); // 100 pips TP
}
else
{
   stopLoss = price + (50 * Point);
   takeProfit = price - (100 * Point);
}

// Add to alert message
string alertMessage = StringFormat(
   "🚨 SIGNAL: %s\n" +
   "Price: %s\n" +
   "SL: %s\n" +
   "TP: %s",
   signalType, DoubleToString(price, Digits),
   DoubleToString(stopLoss, Digits),
   DoubleToString(takeProfit, Digits)
);
```

### Example 3: Volume Confirmation

**Modification**: Add volume filter

```mql4
// Add volume check before signal
long currentVolume = Volume[i];
long avgVolume = iVolume(NULL, 0, i+1) + iVolume(NULL, 0, i+2) + iVolume(NULL, 0, i+3);
avgVolume = avgVolume / 3;

// Only signal if volume is above average
if(currentVolume > avgVolume * 1.5)
{
   // Proceed with signal
}
```

---

## 📊 Performance Benchmarks

### Resource Usage by Configuration

| Strategy      | CPU Usage | Signals/Day | Recommended Charts |
|---------------|-----------|-------------|--------------------|
| Scalping      | Low       | 20-50       | 1-3                |
| Day Trading   | Very Low  | 5-15        | 3-6                |
| Swing Trading | Minimal   | 1-3         | 5-10               |
| Conservative  | Minimal   | <1          | 10+                |

### Alert Delivery Times

| Method   | Typical Delay | Reliability |
|----------|---------------|-------------|
| Telegram | 1-3 seconds   | 99%+        |
| Popup    | Instant       | 100%        |
| Sound    | Instant       | 100%        |
| Email    | 5-60 seconds  | 95%+        |

---

## 🎓 Learning Path

### Beginner Configuration (Week 1-2)

```
FastMA_Period = 10
SlowMA_Period = 30
MinBarsBetweenSignals = 5
AlertOnlyOnNewBar = true
EnableDebugMode = true
Timeframe: H1 or H4
```

**Goal**: Learn how signals work, understand false positives

### Intermediate Configuration (Week 3-4)

```
FastMA_Period = 7
SlowMA_Period = 21
MinBarsBetweenSignals = 4
AlertOnlyOnNewBar = true
EnableDebugMode = false
Timeframe: M15 or M30
```

**Goal**: Start optimizing parameters for your trading style

### Advanced Configuration (Month 2+)

```
Custom modifications
Multiple timeframes
Custom indicators (RSI, MACD)
Session filters
Volume confirmation
```

**Goal**: Build fully customized trading system

---

## 💡 Pro Tips

1. **Start Conservative**: Begin with higher MA periods and increase `MinBarsBetweenSignals`

2. **Backtest First**: Load historical data and see where signals would have appeared

3. **Paper Trade**: Test configurations on demo account for at least 2 weeks

4. **Keep Logs**: Enable debug mode and review terminal logs daily

5. **One Change at a Time**: Only modify one parameter at a time to understand impact

6. **Weekend Optimization**: Use weekends to analyze signals from the week

7. **Seasonal Adjustments**: Different market conditions may require different settings

8. **News Awareness**: Consider disabling alerts during major news events

9. **Multiple Confirmations**: Use indicator on multiple timeframes for confirmation

10. **Regular Review**: Review and adjust settings monthly based on performance

---

## ⚠️ Common Mistakes to Avoid

1. **Too Many Signals**: Using very low MA periods (3/5) in production
2. **Alert Fatigue**: Enabling all alert types and getting overwhelmed
3. **Over-optimization**: Constantly changing parameters without testing
4. **Ignoring Context**: Not considering overall market conditions
5. **Single Timeframe**: Only using one timeframe without confirmation
6. **Disabled `AlertOnlyOnNewBar`**: Allowing repainting signals
7. **No Risk Management**: Trading every signal without proper risk control
8. **Telegram Only**: Relying solely on Telegram without chart verification

---

**Remember**: The best configuration is one that matches YOUR trading style, risk tolerance, and time availability. Start with proven configurations and adjust gradually based on your results.

Happy Trading! 🚀
