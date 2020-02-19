  

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
