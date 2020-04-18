/*
  Script will identify transactions where senders account risk is high and senders country
  risk is low. But money is being transferred from Low risk geography to High risk
  geography for e.g money flowing from canada to Syria.Only those accounts are considered 
  whose source of income is business.
*/
	SELECT 
	    -- Daily transaction Count
	    count(t.transaction_id) AS transaction_ct 
		,sum(t.transaction_amt) AS transaction_amt
		,t.sender_acct
		,a.acct_name
		,a.acct_annual_income
		,a.acct_src_of_income
		,a.acct_industry
		,a.acct_risk
		,t.transaction_date
		,t.send_country_risk
		,t.send_country_name
		,t.reciever_country_risk
		,t.reciever_country_name
	FROM fincrime.transactions t
	    ,fincrime.account a
	-- Wires transactions
	WHERE t.sender_acct=a.acct_id 
	and t.transaction_type = 'Wires' 
	and t.send_country_risk ='Low'
	-- Only where sender's source of income is business
	and a.acct_src_of_income ='Business'
	--Where senders account risk is high
	and a.acct_risk= 'High'
	--Sender from low risk country sending money to high risk geography
	and t.reciever_country_risk ='High'
	GROUP BY t.sender_acct
		,t.transaction_date
		,t.send_country_risk
		,t.reciever_country_risk
		,t.reciever_country_name
		,t.send_country_name
		,a.acct_name
		,a.acct_annual_income
		,a.acct_src_of_income
		,a.acct_industry
		,a.acct_risk
		-- including high dollar value transaction
		having sum(t.transaction_amt) > 10000
		order by transaction_amt desc
		;