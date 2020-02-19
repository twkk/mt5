  

Trade Classes
CAccountInfo       For trade account

CSymbolInfo        For trade instrument 
COrderInfo         For 掛單     pending order
CPositionInfo      For 未平倉頭寸open position

CHistoryOrderInfo  For 歷史order記錄屬性
CDealInfo          For 歷史deal屬性
CTrade             For 交易操作執行
CTerminalInfo      For 終端環境屬性
==========================================================================================
 #include  <Trade \ PositionInfo.mqh> 
 #include <Trade\OrderInfo.mqh>
Class for getting the properties of the terminal environment

 CPositionInfo class 供訪問已開倉位屬性
int
TypeDescription 獲取持倉類型的字符串描述
Time        獲取開倉時間                                    TimeMsc     獲取開倉時間, 數值是自1970年1月1日以來的毫秒數
TimeUpdate  獲取持倉變更時間, 數值是自1970年1月1日以來的秒數  TimeUpdateMsc 獲取持倉變更時間, 數值是自1970年1月1日以來的秒數
PositionType    獲取持倉類型
Magic           獲取開倉的智能交易ID
Identifier   獲取倉位ID
double

Volume        獲取持倉成交量
PriceOpen     獲取開倉價位
StopLoss      獲取持倉的止損價
TakeProfit    獲取持倉的止盈價
PriceCurrent  獲取持倉品種當前價格

Commission    獲取持倉的佣金額度
Swap          獲取倉位的掉期利率額度
Profit        獲取持倉的當前盈利額度

訪問文本型屬性 符號
Symbol        獲取持倉品種的名稱 評論
Comment       獲取持倉的註釋

選擇
Select  選擇持倉
SelectByIndex 	根據索引選擇持倉
SelectByMagic	  根據指定交易品種名稱和幻數選擇持倉
SelectByTicket  根據價格選擇持倉

狀態
StoreState      保存持倉參數
CheckState      檢查當前參數並與保存參數對比

==================================================================================================
Comment
#include <Trade\OrderInfo.mqh>
ORDER_TICKET        訂購票。分配給每個訂單的唯一編號
>>>>ORDER_MAGIC           已下訂單的EA交易的ID（旨在確保每個EA交易都放置自己的唯一編號）<<<<
ORDER_TYPE              訂單類型
ORDER_STATE             訂單狀態  ENUM_ORDER_STATE



ORDER_TIME_SETUP        訂單建立時間          ORDER_TIME_SETUP_MSC    自1970年1月1日以來發出執行訂單的時間（以毫秒為單位）
ORDER_TIME_DONE         訂單執行或取消時間     ORDER_TIME_DONE_MSC     自1970年1月1日以來的訂單執行/取消時間（以毫秒為單位）
ORDER_TIME_EXPIRATION   訂單到期時間
>>>ORDER_TYPE_TIME       訂單壽命             ENUM_ORDER_TYPE_TIME
ORDER_TYPE_FILLING      訂單填寫類型          ENUM_ORDER_TYPE_FILLING

>>ORDER_REASON          下訂單的原因或來源     ENUM_ORDER_REASON

ORDER_POSITION_ID   訂單執行後立即設置為訂單的倉位標識符。每個執行的訂單都會產生一個交易，該交易可以打開或修改現有頭寸。此時，恰好將此位置的標識符設置為執行順序。
ORDER_POSITION_BY_ID用於按訂單平倉的相反頭寸的標識ORDER_TYPE_CLOSE_BY

=========================================================================================
//+------------------------------------------------------------------+
//| Class CTrade.                                                    |
//| Appointment: Class trade operations.                             |
//|              Derives from class CObject.                         |
//+------------------------------------------------------------------+
class CTrade : public CObject
  {
protected:
   MqlTradeRequest   m_request;         // request data
   MqlTradeResult    m_result;          // result data
   MqlTradeCheckResult m_check_result;  // result check data
   bool              m_async_mode;      // trade mode
   ulong             m_magic;           // expert magic number
   ulong             m_deviation;       // deviation default
   ENUM_ORDER_TYPE_FILLING m_type_filling;
   ENUM_ACCOUNT_MARGIN_MODE m_margin_mode;
   //---
   ENUM_LOG_LEVELS   m_log_level;

public:
                     CTrade(void);
                    ~CTrade(void);
   //--- methods of access to protected data
   void              LogLevel(const ENUM_LOG_LEVELS log_level)   { m_log_level=log_level;               }
   void              Request(MqlTradeRequest &request) const;
   ENUM_TRADE_REQUEST_ACTIONS RequestAction(void)          const { return(m_request.action);            }
  ulong             RequestMagic(void)                    const { return(m_request.magic);             }
   ulong             RequestOrder(void)                    const { return(m_request.order);             }
   ulong             RequestPosition(void)                 const { return(m_request.position);          }
   ulong             RequestPositionBy(void)               const { return(m_request.position_by);       }
    string            RequestComment(void)                  const { return(m_request.comment);           }
   //---
   void              Result(MqlTradeResult &result) const;
   //--- trade methods
   void              SetAsyncMode(const bool mode)               { m_async_mode=mode;                   }
   void              SetExpertMagicNumber(const ulong magic)     { m_magic=magic;                       }
   void              SetDeviationInPoints(const ulong deviation) { m_deviation=deviation;               }
   void              SetTypeFilling(const ENUM_ORDER_TYPE_FILLING filling) { m_type_filling=filling;    }
   bool              SetTypeFillingBySymbol(const string symbol);
   void              SetMarginMode(void) { m_margin_mode=(ENUM_ACCOUNT_MARGIN_MODE)AccountInfoInteger(ACCOUNT_MARGIN_MODE); }
   //--- methods for working with positions
   bool              PositionOpen(const string symbol,const ENUM_ORDER_TYPE order_type,const double volume,
                                  const double price,const double sl,const double tp,const string comment="");
   bool              PositionModify(const string symbol,const double sl,const double tp);
   bool              PositionModify(const ulong ticket,const double sl,const double tp);
   bool              PositionClose(const string symbol,const ulong deviation=ULONG_MAX);
   bool              PositionClose(const ulong ticket,const ulong deviation=ULONG_MAX);
   bool              PositionCloseBy(const ulong ticket,const ulong ticket_by);
   bool              PositionClosePartial(const string symbol,const double volume,const ulong deviation=ULONG_MAX);
   bool              PositionClosePartial(const ulong ticket,const double volume,const ulong deviation=ULONG_MAX);
   //--- methods for working with pending orders
   bool              OrderOpen(const string symbol,const ENUM_ORDER_TYPE order_type,const double volume,
                               const double limit_price,const double price,const double sl,const double tp,
                               ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC,const datetime expiration=0,
                               const string comment="");
   bool              OrderModify(const ulong ticket,const double price,const double sl,const double tp,
                                 const ENUM_ORDER_TYPE_TIME type_time,const datetime expiration,const double stoplimit=0.0);
   bool              OrderDelete(const ulong ticket);
   //--- additions methods
   bool              Buy(const double volume,const string symbol=NULL,double price=0.0,const double sl=0.0,const double tp=0.0,const string comment="");
   bool              Sell(const double volume,const string symbol=NULL,double price=0.0,const double sl=0.0,const double tp=0.0,const string comment="");
   bool              BuyLimit(const double volume,const double price,const string symbol=NULL,const double sl=0.0,const double tp=0.0,
                              const ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC,const datetime expiration=0,const string comment="");
   bool              BuyStop(const double volume,const double price,const string symbol=NULL,const double sl=0.0,const double tp=0.0,
                             const ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC,const datetime expiration=0,const string comment="");
   bool              SellLimit(const double volume,const double price,const string symbol=NULL,const double sl=0.0,const double tp=0.0,
                               const ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC,const datetime expiration=0,const string comment="");
   bool              SellStop(const double volume,const double price,const string symbol=NULL,const double sl=0.0,const double tp=0.0,
                              const ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC,const datetime expiration=0,const string comment="");
   //--- method check
     //--- trade request
   string            FormatRequest(string &str,const MqlTradeRequest &request) const;
     //--- position select depending on netting or hedging
   bool              SelectPosition(const string symbol);
  };
