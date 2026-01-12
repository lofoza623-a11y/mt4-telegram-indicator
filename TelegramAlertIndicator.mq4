//+------------------------------------------------------------------+
//|                                        TelegramAlertIndicator.mq4 |
//|                                    Custom MT4 Telegram Indicator |
//|                                    https://github.com/yourrepo    |
//+------------------------------------------------------------------+
#property copyright "Custom MT4 Telegram Alert Indicator"
#property link      "https://github.com/yourrepo"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 clrLime
#property indicator_color2 clrRed
#property indicator_width1 2
#property indicator_width2 2

//--- Input Parameters
input string    Section1 = "========== Telegram Settings ==========";
input string    TelegramBotToken = "";                    // Telegram Bot Token
input string    TelegramChatID = "";                      // Telegram Chat ID
input bool      EnableTelegramAlerts = true;              // Enable Telegram Alerts
input int       MaxRetries = 3;                           // API Request Max Retries
input int       RetryDelayMS = 2000;                      // Retry Delay (milliseconds)

input string    Section2 = "========== Signal Settings ==========";
input int       FastMA_Period = 10;                       // Fast Moving Average Period
input int       SlowMA_Period = 30;                       // Slow Moving Average Period
input ENUM_MA_METHOD MA_Method = MODE_SMA;                // MA Method
input ENUM_APPLIED_PRICE MA_Price = PRICE_CLOSE;          // MA Applied Price
input bool      EnableBuySignals = true;                  // Enable Buy Signals
input bool      EnableSellSignals = true;                 // Enable Sell Signals

input string    Section3 = "========== Alert Settings ==========";
input bool      ShowArrowsOnChart = true;                 // Show Signal Arrows on Chart
input bool      SendPopupAlert = true;                    // Send MT4 Popup Alert
input bool      SendEmailAlert = false;                   // Send Email Alert
input bool      PlaySoundAlert = true;                    // Play Sound Alert
input string    AlertSoundFile = "alert.wav";             // Alert Sound File

input string    Section4 = "========== Advanced Settings ==========";
input int       MinBarsBetweenSignals = 5;                // Minimum Bars Between Same Signals
input bool      AlertOnlyOnNewBar = true;                 // Alert Only on New Bar Formation
input bool      EnableDebugMode = false;                  // Enable Debug Logging

//--- Indicator Buffers
double BuySignalBuffer[];
double SellSignalBuffer[];

//--- Global Variables
datetime lastAlertTime = 0;
int lastSignalBar = -1;
string lastSignalType = "";
int lastBuySignalBar = -1;
int lastSellSignalBar = -1;

//--- Import Windows API for HTTP requests
#import "wininet.dll"
   int InternetOpenW(string, int, string, string, int);
   int InternetOpenUrlW(int, string, string, int, int, int);
   int InternetReadFile(int, uchar &buffer[], int, int &OneInt[]);
   int InternetCloseHandle(int);
#import

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   //--- Indicator buffers mapping
   SetIndexBuffer(0, BuySignalBuffer);
   SetIndexBuffer(1, SellSignalBuffer);
   
   //--- Set indicator styles
   SetIndexStyle(0, DRAW_ARROW);
   SetIndexArrow(0, 233);  // Up arrow
   SetIndexStyle(1, DRAW_ARROW);
   SetIndexArrow(1, 234);  // Down arrow
   
   //--- Set indicator labels
   SetIndexLabel(0, "Buy Signal");
   SetIndexLabel(1, "Sell Signal");
   
   //--- Initialize buffers
   ArraySetAsSeries(BuySignalBuffer, true);
   ArraySetAsSeries(SellSignalBuffer, true);
   
   //--- Validation
   if(FastMA_Period >= SlowMA_Period)
   {
      Alert("ERROR: Fast MA Period must be less than Slow MA Period!");
      return(INIT_PARAMETERS_INCORRECT);
   }
   
   if(EnableTelegramAlerts && (TelegramBotToken == "" || TelegramChatID == ""))
   {
      Alert("WARNING: Telegram alerts enabled but Bot Token or Chat ID is empty!");
      Print("Please configure TelegramBotToken and TelegramChatID in indicator settings.");
   }
   
   //--- Set indicator short name
   string shortName = StringFormat("Telegram Alert (%d/%d MA)", FastMA_Period, SlowMA_Period);
   IndicatorShortName(shortName);
   
   if(EnableDebugMode)
      Print("Telegram Alert Indicator initialized successfully");
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   if(EnableDebugMode)
      Print("Telegram Alert Indicator deinitialized. Reason: ", reason);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   //--- Set arrays as series
   ArraySetAsSeries(time, true);
   ArraySetAsSeries(close, true);
   ArraySetAsSeries(high, true);
   ArraySetAsSeries(low, true);
   
   //--- Check if we have enough bars
   if(rates_total < SlowMA_Period + 2)
      return(0);
   
   //--- Calculate starting position
   int limit = rates_total - prev_calculated;
   if(limit > 1)
      limit = rates_total - SlowMA_Period - 1;
   
   //--- Main calculation loop
   for(int i = limit; i >= 0; i--)
   {
      //--- Initialize buffers
      BuySignalBuffer[i] = EMPTY_VALUE;
      SellSignalBuffer[i] = EMPTY_VALUE;
      
      //--- Calculate Moving Averages
      double fastMA_current = iMA(NULL, 0, FastMA_Period, 0, MA_Method, MA_Price, i);
      double slowMA_current = iMA(NULL, 0, SlowMA_Period, 0, MA_Method, MA_Price, i);
      double fastMA_previous = iMA(NULL, 0, FastMA_Period, 0, MA_Method, MA_Price, i + 1);
      double slowMA_previous = iMA(NULL, 0, SlowMA_Period, 0, MA_Method, MA_Price, i + 1);
      
      //--- Detect Buy Signal (Fast MA crosses above Slow MA)
      if(EnableBuySignals && 
         fastMA_previous <= slowMA_previous && 
         fastMA_current > slowMA_current)
      {
         if(ShowArrowsOnChart)
            BuySignalBuffer[i] = low[i] - (10 * Point);
         
         //--- Send alert only for the most recent confirmed signal
         if(i == 0 || (i == 1 && AlertOnlyOnNewBar))
         {
            int currentBar = i;
            if(AlertOnlyOnNewBar)
               currentBar = 1;  // Alert on bar 1 (newly formed bar)
            
            //--- Check if enough bars have passed since last buy signal
            if(lastBuySignalBar == -1 || (Bars - currentBar) - (Bars - lastBuySignalBar) >= MinBarsBetweenSignals)
            {
               SendAlert("BUY", close[currentBar], time[currentBar], currentBar);
               lastBuySignalBar = currentBar;
            }
         }
      }
      
      //--- Detect Sell Signal (Fast MA crosses below Slow MA)
      if(EnableSellSignals && 
         fastMA_previous >= slowMA_previous && 
         fastMA_current < slowMA_current)
      {
         if(ShowArrowsOnChart)
            SellSignalBuffer[i] = high[i] + (10 * Point);
         
         //--- Send alert only for the most recent confirmed signal
         if(i == 0 || (i == 1 && AlertOnlyOnNewBar))
         {
            int currentBar = i;
            if(AlertOnlyOnNewBar)
               currentBar = 1;  // Alert on bar 1 (newly formed bar)
            
            //--- Check if enough bars have passed since last sell signal
            if(lastSellSignalBar == -1 || (Bars - currentBar) - (Bars - lastSellSignalBar) >= MinBarsBetweenSignals)
            {
               SendAlert("SELL", close[currentBar], time[currentBar], currentBar);
               lastSellSignalBar = currentBar;
            }
         }
      }
   }
   
   //--- Return value of prev_calculated for next call
   return(rates_total);
}

//+------------------------------------------------------------------+
//| Send Alert Function                                              |
//+------------------------------------------------------------------+
void SendAlert(string signalType, double price, datetime signalTime, int barIndex)
{
   //--- Prevent duplicate alerts
   if(lastSignalType == signalType && lastSignalBar == barIndex)
      return;
   
   lastSignalType = signalType;
   lastSignalBar = barIndex;
   lastAlertTime = TimeCurrent();
   
   //--- Format alert message
   string symbol = Symbol();
   string timeframe = GetTimeframeString(Period());
   string priceStr = DoubleToString(price, Digits);
   string timeStr = TimeToString(signalTime, TIME_DATE | TIME_MINUTES);
   
   string alertMessage = StringFormat(
      "🚨 TRADING SIGNAL ALERT 🚨\n\n" +
      "Signal: %s\n" +
      "Pair: %s\n" +
      "Timeframe: %s\n" +
      "Price: %s\n" +
      "Indicator: MA Crossover (%d/%d)\n" +
      "Time: %s\n\n" +
      "⚠️ Always verify signals before trading!",
      signalType, symbol, timeframe, priceStr, FastMA_Period, SlowMA_Period, timeStr
   );
   
   if(EnableDebugMode)
      Print("Signal detected: ", signalType, " at ", priceStr);
   
   //--- Send Telegram Alert
   if(EnableTelegramAlerts && TelegramBotToken != "" && TelegramChatID != "")
   {
      bool telegramSent = SendTelegramMessage(alertMessage);
      if(EnableDebugMode)
         Print("Telegram alert sent: ", telegramSent);
   }
   
   //--- Send MT4 Popup Alert
   if(SendPopupAlert)
   {
      Alert(StringFormat("%s Signal on %s %s at %s", signalType, symbol, timeframe, priceStr));
   }
   
   //--- Play Sound Alert
   if(PlaySoundAlert)
   {
      PlaySound(AlertSoundFile);
   }
   
   //--- Send Email Alert (if configured in MT4)
   if(SendEmailAlert)
   {
      string emailSubject = StringFormat("%s Signal - %s %s", signalType, symbol, timeframe);
      SendMail(emailSubject, alertMessage);
   }
}

//+------------------------------------------------------------------+
//| Send Telegram Message Function                                   |
//+------------------------------------------------------------------+
bool SendTelegramMessage(string message)
{
   //--- URL encode the message
   string encodedMessage = UrlEncode(message);
   
   //--- Construct Telegram API URL
   string url = StringFormat(
      "https://api.telegram.org/bot%s/sendMessage?chat_id=%s&text=%s&parse_mode=HTML",
      TelegramBotToken, TelegramChatID, encodedMessage
   );
   
   //--- Send request with retry logic
   for(int attempt = 1; attempt <= MaxRetries; attempt++)
   {
      if(EnableDebugMode)
         Print("Sending Telegram message, attempt ", attempt, " of ", MaxRetries);
      
      string response = "";
      bool success = HttpRequest(url, response);
      
      if(success)
      {
         if(EnableDebugMode)
            Print("Telegram message sent successfully: ", response);
         return true;
      }
      else
      {
         Print("Failed to send Telegram message, attempt ", attempt, ": ", response);
         
         if(attempt < MaxRetries)
         {
            if(EnableDebugMode)
               Print("Retrying in ", RetryDelayMS, " ms...");
            Sleep(RetryDelayMS);
         }
      }
   }
   
   Print("ERROR: Failed to send Telegram message after ", MaxRetries, " attempts");
   return false;
}

//+------------------------------------------------------------------+
//| HTTP Request Function using WinINet                              |
//+------------------------------------------------------------------+
bool HttpRequest(string url, string &response)
{
   int hInternet = InternetOpenW("MT4 Telegram Bot", 0, "", "", 0);
   if(hInternet == 0)
   {
      Print("ERROR: InternetOpenW failed");
      return false;
   }
   
   int hUrl = InternetOpenUrlW(hInternet, url, "", 0, 0, 0);
   if(hUrl == 0)
   {
      Print("ERROR: InternetOpenUrlW failed");
      InternetCloseHandle(hInternet);
      return false;
   }
   
   uchar buffer[];
   ArrayResize(buffer, 4096);
   int bytesRead[1];
   string result = "";
   
   while(InternetReadFile(hUrl, buffer, ArraySize(buffer), bytesRead))
   {
      if(bytesRead[0] <= 0)
         break;
      result += CharArrayToString(buffer, 0, bytesRead[0], CP_UTF8);
   }
   
   InternetCloseHandle(hUrl);
   InternetCloseHandle(hInternet);
   
   response = result;
   
   //--- Check if response contains "ok":true
   if(StringFind(response, "\"ok\":true") >= 0)
      return true;
   
   return false;
}

//+------------------------------------------------------------------+
//| URL Encode Function                                              |
//+------------------------------------------------------------------+
string UrlEncode(string str)
{
   string result = "";
   uchar ch[];
   int len = StringToCharArray(str, ch, 0, WHOLE_ARRAY, CP_UTF8) - 1;
   
   for(int i = 0; i < len; i++)
   {
      uchar c = ch[i];
      
      //--- Keep alphanumeric and safe characters
      if((c >= 48 && c <= 57) ||   // 0-9
         (c >= 65 && c <= 90) ||   // A-Z
         (c >= 97 && c <= 122) ||  // a-z
         c == 45 || c == 46 || c == 95 || c == 126) // - . _ ~
      {
         result += CharToString(c);
      }
      //--- Encode space as +
      else if(c == 32)
      {
         result += "+";
      }
      //--- Percent-encode everything else
      else
      {
         result += StringFormat("%%%02X", c);
      }
   }
   
   return result;
}

//+------------------------------------------------------------------+
//| Get Timeframe String Function                                    |
//+------------------------------------------------------------------+
string GetTimeframeString(int period)
{
   switch(period)
   {
      case PERIOD_M1:  return "M1";
      case PERIOD_M5:  return "M5";
      case PERIOD_M15: return "M15";
      case PERIOD_M30: return "M30";
      case PERIOD_H1:  return "H1";
      case PERIOD_H4:  return "H4";
      case PERIOD_D1:  return "D1";
      case PERIOD_W1:  return "W1";
      case PERIOD_MN1: return "MN1";
      default:         return "Unknown";
   }
}
