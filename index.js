const express = require('express');
const puppeteer = require('puppeteer');

const app = express();

app.get('/stock-price/:symbol', async (req, res) => {
  try {
    const symbol = req.params.symbol.toLowerCase();

    if (!symbol) {
      return res.status(400).json({ error: 'Symbol is required' });
    }

    console.log("Fetching stock price for " + symbol);
    
    // Launch headless browser
      const browser = await puppeteer.launch({
        args: ['--no-sandbox', '--disable-setuid-sandbox'],
      });
      
      console.log("Headless browser launched");

    const page = await browser.newPage();

    console.log("Page opened");
    
    // Navigate to Google search
    await page.goto(`https://www.google.com/search?q=${symbol}+stock+price`);
    
    // Wait for the stock price to load
    await page.waitForSelector('g-card-section > div > div > span:nth-child(1) > span > span');
    
    // Extract the stock price
    const stockPrice = await page.$eval('g-card-section > div > div > span:nth-child(1) > span > span', element => element.textContent);
    const stockFullName = await page.$eval('#rcnt > div.XqFnDf > div > div > div.wPNfjb > div > div.hHq9Z > div > div > div.MDY31c > div.QpPSMb > div > div', element => element.textContent);
      console.log( "Stock price: " + stockPrice);
      
    // Close the browser
    await browser.close();
    
    // Respond with the stock price
    res.json({ symbol, stockPrice,stockFullName });
  } catch (error) {
    console.error('Error fetching stock price:', error);
    res.status(500).json({ error: 'Failed to fetch stock price' });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
