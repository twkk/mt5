//+------------------------------------------------------------------+
//|                                                    CRRDialog.mqh |
//|                                      Copyright 2010, Investeo.pl |
//|                                           http://www.investeo.pl |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, Investeo.pl"
#property link      "http://www.investeo.pl"

#include <ChartObjects\ChartObjectsBmpControls.mqh>
#include <ChartObjects\ChartObjectsTxtControls.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CRRDialog
  {
private:

   int               m_baseX;
   int               m_baseY;
   int               m_fontSize;

   string            m_font;
   string            m_dialogName;
   string            m_bgFileName;

   double            m_RRRatio;
   double            m_riskPercent;
   double            m_orderLots;
   double            m_SL;
   double            m_TP;
   double            m_maxAllowedLots;
   double            m_maxTicksLoss;
   double            m_orderEquityRisk;
   double            m_orderEquityReward;
   ENUM_ORDER_TYPE   m_orderType;

   CChartObjectBmpLabel m_bgDialog;

   CChartObjectEdit  m_riskRatioEdit;
   CChartObjectEdit  m_riskValueEdit;
   CChartObjectEdit  m_orderLotsEdit;

   CChartObjectLabel m_symbolNameLabel;
   CChartObjectLabel m_tickSizeLabel;
   CChartObjectLabel m_maxEquityLossLabel;
   CChartObjectLabel m_equityLabel;
   CChartObjectLabel m_profitValueLabel;
   CChartObjectLabel m_askLabel;
   CChartObjectLabel m_bidLabel;
   CChartObjectLabel m_tpLabel;
   CChartObjectLabel m_slLabel;
   CChartObjectLabel m_maxAllowedLotsLabel;
   CChartObjectLabel m_maxTicksLossLabel;
   CChartObjectLabel m_orderEquityRiskLabel;
   CChartObjectLabel m_orderEquityRewardLabel;
   CChartObjectLabel m_orderTypeLabel;

   CChartObjectButton m_switchOrderTypeButton;
   CChartObjectButton m_placeOrderButton;
   CChartObjectButton m_quitEAButton;

public:

   void              CRRDialog(); // CRRDialog constructor
   void             ~CRRDialog(); // CRRDialog constructor

   bool              CreateCRRDialog(int topX,int leftY);
   int               DeleteCRRDialog();
   void              Refresh();
   void              SetRRRatio(double RRRatio);
   void              SetRiskPercent(double riskPercent);
   double            GetRiskPercent();
   double            GetRRRRatio();
   void              SetSL(double sl);
   void              SetTP(double tp);
   double            GetSL();
   double            GetTP();
   void              SetMaxAllowedLots(double lots);
   void              SetMaxTicksLoss(double ticks);
   void              SetOrderType(ENUM_ORDER_TYPE);
   void              SwitchOrderType();
   void              ResetButtons();
   ENUM_ORDER_TYPE   GetOrderType();
   void              SetOrderLots(double orderLots);
   double            GetOrderLots();
   void              SetOrderEquityRisk(double equityRisk);
   void              SetOrderEquityReward(double equityReward);
  };
//+------------------------------------------------------------------+

void CRRDialog::CRRDialog(void)
  {
   m_dialogName="RRDialog";
   m_font="Verdana";
   m_fontSize=11;
   m_bgFileName="rrea.bmp";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CRRDialog::~CRRDialog(void)
  {
// delete dynamic objects
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CRRDialog::CreateCRRDialog(int topX,int leftY)
  {
   bool isCreated=true;

   MqlTick current_tick;
   SymbolInfoTick(Symbol(),current_tick);

   m_baseX = topX;
   m_baseY = leftY;

   isCreated&=m_bgDialog.Create(0,m_dialogName,0,topX,leftY);
   m_bgDialog.BmpFileOn(m_bgFileName);

   isCreated&=m_symbolNameLabel.Create(0,"symbolNameLabel",0,m_baseX+120,m_baseY+40);
   m_symbolNameLabel.Font("Verdana");
   m_symbolNameLabel.FontSize(8);
   m_symbolNameLabel.Description(Symbol());

   isCreated&=m_tickSizeLabel.Create(0,"tickSizeLabel",0,m_baseX+120,m_baseY+57);
   m_tickSizeLabel.Font("Verdana");
   m_tickSizeLabel.FontSize(8);
   m_tickSizeLabel.Description(DoubleToString(SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_SIZE), Digits()));

   isCreated&=m_riskRatioEdit.Create(0,"riskRatioEdit",0,m_baseX+120,m_baseY+72,35,15);
   m_riskRatioEdit.Font("Verdana");
   m_riskRatioEdit.FontSize(8);
   m_riskRatioEdit.Description(DoubleToString(m_RRRatio, 2));

   isCreated&=m_riskValueEdit.Create(0,"riskValueEdit",0,m_baseX+120,m_baseY+90,35,15);
   m_riskValueEdit.Font("Verdana");
   m_riskValueEdit.FontSize(8);
   m_riskValueEdit.Description(DoubleToString(m_riskPercent, 2));

   isCreated&=m_equityLabel.Create(0,"equityLabel",0,m_baseX+120,m_baseY+107);
   m_equityLabel.Font("Verdana");
   m_equityLabel.FontSize(8);
   m_equityLabel.Description(DoubleToString(AccountInfoDouble(ACCOUNT_EQUITY),2));

   isCreated&=m_maxEquityLossLabel.Create(0,"maxEquityLossLabel",0,m_baseX+120,m_baseY+122);
   m_maxEquityLossLabel.Font("Verdana");
   m_maxEquityLossLabel.FontSize(8);
   m_maxEquityLossLabel.Description(DoubleToString(AccountInfoDouble(ACCOUNT_EQUITY)*m_riskPercent/100.0,2));

   isCreated&=m_askLabel.Create(0,"askLabel",0,m_baseX+120,m_baseY+145);
   m_askLabel.Font("Verdana");
   m_askLabel.FontSize(8);
   m_askLabel.Description("");

   isCreated&=m_bidLabel.Create(0,"bidLabel",0,m_baseX+120,m_baseY+160);
   m_bidLabel.Font("Verdana");
   m_bidLabel.FontSize(8);
   m_bidLabel.Description("");

   isCreated&=m_slLabel.Create(0,"slLabel",0,m_baseX+120,m_baseY+176);
   m_slLabel.Font("Verdana");
   m_slLabel.FontSize(8);
   m_slLabel.Description("");

   isCreated&=m_tpLabel.Create(0,"tpLabel",0,m_baseX+120,m_baseY+191);
   m_tpLabel.Font("Verdana");
   m_tpLabel.FontSize(8);
   m_tpLabel.Description("");

   isCreated&=m_maxAllowedLotsLabel.Create(0,"maxAllowedLotsLabel",0,m_baseX+120,m_baseY+208);
   m_maxAllowedLotsLabel.Font("Verdana");
   m_maxAllowedLotsLabel.FontSize(8);
   m_maxAllowedLotsLabel.Description("");

   isCreated&=m_maxTicksLossLabel.Create(0,"maxTicksLossLabel",0,m_baseX+120,m_baseY+223);
   m_maxTicksLossLabel.Font("Verdana");
   m_maxTicksLossLabel.FontSize(8);
   m_maxTicksLossLabel.Description("");

   isCreated&=m_orderLotsEdit.Create(0,"orderLotsEdit",0,m_baseX+120,m_baseY+238,35,15);
   m_orderLotsEdit.Font("Verdana");
   m_orderLotsEdit.FontSize(8);
   m_orderLotsEdit.Description("");

   isCreated&=m_orderEquityRiskLabel.Create(0,"orderEquityRiskLabel",0,m_baseX+120,m_baseY+255);
   m_orderEquityRiskLabel.Font("Verdana");
   m_orderEquityRiskLabel.FontSize(8);
   m_orderEquityRiskLabel.Description("");

   isCreated&=m_orderEquityRewardLabel.Create(0,"orderEquityRewardLabel",0,m_baseX+120,m_baseY+270);
   m_orderEquityRewardLabel.Font("Verdana");
   m_orderEquityRewardLabel.FontSize(8);
   m_orderEquityRewardLabel.Description("");


   isCreated&=m_switchOrderTypeButton.Create(0,"switchOrderTypeButton",0,m_baseX+20,m_baseY+314,160,20);
   m_switchOrderTypeButton.Font("Verdana");
   m_switchOrderTypeButton.FontSize(8);
   m_switchOrderTypeButton.BackColor(LightBlue);

   isCreated&=m_placeOrderButton.Create(0,"placeOrderButton",0,m_baseX+20,m_baseY+334,160,20);
   m_placeOrderButton.Font("Verdana");
   m_placeOrderButton.FontSize(8);
   m_placeOrderButton.BackColor(LightBlue);
   m_placeOrderButton.Description("Place Market Order");


   isCreated&=m_quitEAButton.Create(0,"quitEAButton",0,m_baseX+20,m_baseY+354,160,20);
   m_quitEAButton.Font("Verdana");
   m_quitEAButton.FontSize(8);
   m_quitEAButton.BackColor(LightBlue);
   m_quitEAButton.Description("Quit");

   return isCreated;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CRRDialog::Refresh()
  {
   MqlTick current_tick;
   SymbolInfoTick(Symbol(),current_tick);

   m_equityLabel.Description(DoubleToString(AccountInfoDouble(ACCOUNT_EQUITY),2));
   m_maxEquityLossLabel.Description(DoubleToString(AccountInfoDouble(ACCOUNT_EQUITY)*StringToDouble(m_riskValueEdit.Description())/100.0,2));
   m_askLabel.Description(DoubleToString(current_tick.ask, Digits()));
   m_bidLabel.Description(DoubleToString(current_tick.bid, Digits()));
   m_slLabel.Description(DoubleToString(m_SL, Digits()));
   m_tpLabel.Description(DoubleToString(m_TP, Digits()));
   m_maxAllowedLotsLabel.Description(DoubleToString(m_maxAllowedLots,2));
   m_maxTicksLossLabel.Description(DoubleToString(m_maxTicksLoss,0));
   m_orderEquityRiskLabel.Description(DoubleToString(m_orderEquityRisk,2));
   m_orderEquityRewardLabel.Description(DoubleToString(m_orderEquityReward,2));

   if(m_orderType==ORDER_TYPE_BUY) m_switchOrderTypeButton.Description("Order Type: BUY");
   else if(m_orderType==ORDER_TYPE_SELL) m_switchOrderTypeButton.Description("Order Type: SELL");
  }
//+------------------------------------------------------------------+
void CRRDialog::SetRRRatio(double RRRatio)
  {
   m_RRRatio=RRRatio;
  }
//+------------------------------------------------------------------+

double CRRDialog::GetRRRRatio(void)
  {
   return StringToDouble(m_riskRatioEdit.Description());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CRRDialog::SetRiskPercent(double riskPercent)
  {
   m_riskPercent=riskPercent;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CRRDialog::GetRiskPercent()
  {
   return StringToDouble(m_riskValueEdit.Description());
  }
//+------------------------------------------------------------------+
void CRRDialog::SetSL(double sl)
  {
   m_SL=sl;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CRRDialog::SetTP(double tp)
  {
   m_TP=tp;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CRRDialog::GetSL(void)
  {
   return m_SL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CRRDialog::GetTP(void)
  {
   return m_TP;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CRRDialog::SetMaxAllowedLots(double allowedLots)
  {
   m_maxAllowedLots=allowedLots;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CRRDialog::SetMaxTicksLoss(double ticks)
  {
   m_maxTicksLoss=ticks;
  }
//+------------------------------------------------------------------+
void CRRDialog::SetOrderType(ENUM_ORDER_TYPE orderType)
  {
   m_orderType=orderType;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE CRRDialog::GetOrderType(void)
  {
   return m_orderType;
  }
//+------------------------------------------------------------------+
void CRRDialog::SwitchOrderType(void)
  {
   m_orderType=(m_orderType==ORDER_TYPE_BUY) ? ORDER_TYPE_SELL : ORDER_TYPE_BUY;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CRRDialog::SetOrderLots(double orderLots)
  {
   m_orderLots=orderLots;
   m_orderLotsEdit.Description(DoubleToString(m_orderLots,2));

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CRRDialog::GetOrderLots()
  {
   return StringToDouble(m_orderLotsEdit.Description());

  }
//+------------------------------------------------------------------+
void CRRDialog::SetOrderEquityRisk(double equityRisk)
  {
   m_orderEquityRisk=equityRisk;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CRRDialog::SetOrderEquityReward(double equityReward)
  {
   m_orderEquityReward=equityReward;
  }
//+------------------------------------------------------------------+
void CRRDialog::ResetButtons()
  {
   m_placeOrderButton.State(false);
   m_switchOrderTypeButton.State(false);
  }
//+------------------------------------------------------------------+
