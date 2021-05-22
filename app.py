from flask import Flask, request, jsonify
from yahoo_fin import stock_info as si
from datetime import date, time, datetime,timedelta
from bs4 import BeautifulSoup as soup
from urllib.request import urlopen
from time import time
import json
import pandas as pd


app = Flask(__name__)

@app.route('/getliveprice/<ticker>',methods=['GET'])
def liveprice(ticker):
    ticker = list(ticker.split(","))
    priceframe = pd.DataFrame(columns = {"stockprice"})
    n = 0
    for i in ticker:
        stockprice = si.get_live_price(i)
        stockprice = round(stockprice,2)
        priceframe.at[n,'stockprice'] = stockprice
        n = n+1
    return priceframe.to_json(orient = "records")

@app.route('/getquote',methods=['GET'])
def quotetable():
    ticker = str(request.args['stktkr'])
    stockdata = si.get_quote_table(ticker)
    l = ['Open','Previous Close','52 Week Range','Market Cap',"Day's Range","Avg. Volume","Market Cap","Volume","Quote Price"]
    stockframe = {}
    for i in l:
        x = stockdata.get(i)
        if (i == 'Quote Price'):
            x = round(x,2)
        stockframe[i] = x
    return jsonify(stockframe)

@app.route('/scrapenews',methods = ['GET'])
def webCrawl():
    search = str(request.args['search'])
    news_df = pd.DataFrame(columns={"Headline", "Date_time", "URL"})
    date = datetime.now()
    date = date.date() - timedelta(days=2)
    date = str(date)
    date = date.replace("-", "")
    date = int(date)
    search = search.replace(" ", "%20")
    search = search.replace("Limited", "")
    search = search.replace("ltd", "")
    search = search.replace("INC", "")
    search = search.replace("inc", "")
    search = search.replace("LLC", "")
    newsUrl = "https://news.google.com/rss/?q=" + str(search)
    website = urlopen(newsUrl)
    xml_page = website.read()
    website.close()
    ret_n = pd.DataFrame(columns=[""])
    soup_page = soup(xml_page, "xml")
    news_list = soup_page.findAll("item")
    for news in news_list:
        day = (news.pubDate.text[5:7])
        wkday = str(news.pubDate.text[0:4])
        pub_time = str(news.pubDate.text[17:25])
        d = {"Jan" : "01", "Feb" : "02", "Mar" : "03", "Apr" : "04", "May" : "05", "Jun" : "06", "Jul" : "07", "Aug" : "08", "Sep" : "09", "Oct" : "10", "Nov" : "11", "Dec" : "12"}
        month = (d.get(news.pubDate.text[8:11]))
        year = (news.pubDate.text[12:16])
        date_t = str(year + "-" + month + "-" + day + " " +pub_time)
        format = "%Y-%m-%d %H:%M:%S"
        date_time = datetime.strptime(date_t, format) + timedelta(minutes = 330)
        date_time = wkday + str(date_time)
        date_a = int(str(year + month + day))

        if (date_a >= date):
            headl = news.title.text
            newslink = news.link.text
            news_df = news_df.append({"Headline": headl, "Date_time" : date_time, "URL": newslink}, ignore_index=True)
    return news_df.to_json(orient='records')

@app.route('/getmath/<ticker>/<delta>/<pricelist>',methods=['GET'])
def quotetable1(ticker,delta,pricelist):
    ret_s = pd.DataFrame(columns=["share_n", "timestamp", "w", "x"])
    ticker = list(ticker.split(","))
    delta = list(delta.split(","))
    pricelist = list(pricelist.split(","))
    n = 0
    for m in range(len(ticker)):
        share = ticker[m]
        delta1 = delta[m]
        save = pricelist[m]
        tdy = date.today()
        ydy = date.today() - timedelta(days=1)
        sdy = date.today() - timedelta(days=1500)
        dma50 = si.get_data(share, start_date=sdy, end_date=tdy, interval="1d").close.to_frame()
        dma50["ma"] = dma50.close.rolling(window=50).mean()
        dma50 = dma50.tail(1)
        dma50.index = [0]
        ma50 = dma50.at[0, "ma"]
        hist = si.get_data(share, start_date=tdy, interval="1m").close.to_frame()
        hist ["timestamp"] = hist.index
        hist = hist.tail(15)
        hist.index = range(0, 15, 1)
        w = False
        x = False
        for i in range(0, 14, 1):
            mini = float(save) - float(delta1)
            maxi = float(save) + float(delta1)
            cur_price = si.get_live_price(share)
            if cur_price >= maxi:
                w = True
                x = True
                n = int(n)
                ret_s.at [n, "w"] = w
                ret_s.at [n, "x"] = x
                ret_s.at [n, "share_n"] = int(m)
                ret_s.at[n, "timestamp"] = hist.at[i, "timestamp"]
                n = n + 1
                break
            elif cur_price <= mini:
                w = True
                x = False
                ret_s.at[n, "w"] = w
                ret_s.at[n, "x"] = x
                ret_s.at[n, "share_n"] = int(m)
                ret_s.at[n, "timestamp"] = hist.at[i, "timestamp"]
                n = n + 1
                break
        n = n
    return ret_s.to_json(orient='records')        
    

@app.route("/historicaldata/1d",methods = ['GET'])
def hist():
    ticker = str(request.args['stktkr'])
    x = date.today()
    if(x.weekday() == 6):
        x = x - timedelta(days = 2)
    elif(x.weekday() == 5):
        x = x - timedelta(days = 1)
    else:
        pass
    df = {}
    try:
        df = si.get_data(ticker, start_date= x , interval= "1m")
        df = df[['open','close','high','low']].round(3)
        df = df.reset_index()
        df = df.rename(columns = {"index":"timestamp"})
        df = df.to_json( orient = 'records')
        return df
    except:
        df = si.get_data(ticker,start_date = x - timedelta(days = 1),interval="1m")
        df = df[['open','close','high','low']].round(3)
        df = df.reset_index()
        df = df.rename(columns = {"index":"timestamp"})
        df = df.to_json( orient = 'records')   
        return df


@app.route("/historicaldata/7d",methods = ['GET'])
def hist7d():
    ticker = str(request.args['stktkr'])
    x = date.today() - timedelta(days= 6)
    if(x.weekday() == 6):
        x = x + timedelta(days = 1)
    elif(x.weekday() == 5):
        x = x + timedelta(days = 2)
    else:
        pass
    df = {}
    df = si.get_data(ticker, start_date= x , interval= "1m")
    df = df.iloc[::5, :]
    df = df[['open','close','high','low']].round(3)
    df = df.reset_index()
    df = df.rename(columns = {"index":"timestamp"})
    df = df.to_json(orient = 'records')
    return df


@app.route("/historicaldata/1m",methods = ['GET'])
def hist1m():
    ticker = str(request.args['stktkr'])
    x = date.today() - timedelta(days= 31)
    df = {}
    df = si.get_data(ticker, start_date= x , interval= "1d")
    df = df[['open','close','high','low']].round(3)
    df = df.reset_index()
    df = df.rename(columns = {"index":"timestamp"})
    df = df.to_json(orient = 'records')
    return df

@app.route("/historicaldata/6m",methods = ['GET'])
def hist6m():
    ticker = str(request.args['stktkr'])
    x = date.today() - timedelta(days= 182)
    df = {}
    df = si.get_data(ticker, start_date= x , interval= "1d")
    df = df[['open','close','high','low']].round(3)
    df = df.reset_index()
    df = df.rename(columns = {"index":"timestamp"})
    df = df.to_json(orient = 'records')
    return df

@app.route("/historicaldata/1y",methods = ['GET'])
def hist1y():
    ticker = str(request.args['stktkr'])
    x = date.today() - timedelta(days= 365)
    df = {}
    df = si.get_data(ticker, start_date= x , interval= "1d")
    df = df[['open','close','high','low']].round(3)
    df = df.reset_index()
    df = df.rename(columns = {"index":"timestamp"})
    df = df.to_json(orient = 'records')
    return df

@app.route("/getmath/<ticker>",methods = ['GET'])
def analysis_lt(ticker):
    ret_l = pd.DataFrame(columns=["change", "pos", "indi"])
    share_list = list(ticker.split(","))
    for share in share_list:
        market = None
        if share[-2:] == "NS":
            market = "^NSEI"
        elif share[-2:] == "BO":
            market = "BSE-500.BO"
        tdy = date.today()
        sdy = tdy - timedelta(days = 1851)
        hist = si.get_data(market, start_date= sdy, interval= "1d").close.to_frame()
        hist_comp = si.get_data(share, start_date= sdy, interval= "1d").close.to_frame()
        hist_comp = hist_comp.tail(15)
        hist_comp ["close"] = hist_comp.close.__round__(3)
        hist.columns = ["close"]
        hist ["date"] = hist.index
        hist_comp ["inx"] = range(1, 16, 1)
        hist_comp = hist_comp.set_index("inx")
        hist ["ma200"] = hist.close.ewm(span=200).mean()
        tdyma = hist.tail(1)
        tdy_close = float(hist.iat[-1, 0]).__round__(3)
        dma200 = float(tdyma.ma200).__round__(3)
        change = [0] * 14
        pos = 0
        neg = 0
        for i in range(1, 15, 1):
            change[i - 1] = float(hist_comp.close[i + 1] - hist_comp.close[i])
            if (change[i - 1] >= 0):
                pos = pos + change[i - 1]
            else:
                neg = neg + change[i - 1]
        neg = -neg / 14
        pos = pos / 14
        rs = pos / neg
        rsi = (100 - (100 / (1 + rs))).__round__(3)
        x = False
        y = False
        if (dma200 < tdy_close):
            if (rsi <= 30):
                x = True
                y = False
                ret_l = ret_l.append({"change" : x, "pos" : y,"indi": rsi}, ignore_index= True)
            elif(rsi >= 70):
                x = True
                y = True
                ret_l = ret_l.append({"change" : x, "pos" : y,"indi": rsi}, ignore_index= True)
            else:
                x = False
                y = False
                ret_l = ret_l.append({"change": x, "pos": y, "indi": rsi}, ignore_index=True)
        elif (dma200 > tdy_close):
            if (rsi >= 70):
                x = True
                y = True
                ret_l = ret_l.append({"change": x, "pos": y, "indi": rsi}, ignore_index=True)
            else:
                x = False
                y = False
                ret_l = ret_l.append({"change": x, "pos": y, "indi": rsi}, ignore_index=True)
        else:
            ret_l = ret_l.append({"change": x, "pos": y, "indi": rsi}, ignore_index=True)
    return ret_l.to_json(orient='records')

if __name__ == '__main__':
    app.run(debug = True)