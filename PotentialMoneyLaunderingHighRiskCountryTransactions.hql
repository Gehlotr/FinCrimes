/* 
Script will return rcords where money recieved in an account is considerably higher than the 
annual stated income for and account and money is flowing from a high risk country to a low risk 
country. For e.g someone from yemen is transferring a huge sum of money to someone in France raise
suspicion and these type of transactions must be monitored closely to understand the actual purpose 
of the transaction bewteen both the parties.These types of transactions might be related to Money 
Laundering or terrorist financing activities.
*/
	SELECT count(t.transaction_id) AS transaction_ct -- Daily transaction Count
		,sum(t.transaction_amt) AS transaction_amt
		,t.sender_acct
		,t.reciever_acct as recieving_acct_id
		,a.acct_name as recieving_acct_name
		,a.acct_annual_income as recieving_acct_annual_income
		,a.acct_src_of_income as recieving_acct_src_income
		,a.acct_industry
		,a.acct_risk
		,t.transaction_date
		,t.send_country_risk
		,t.send_country_name
		,t.reciever_country_risk
		,t.reciever_country_name
	FROM fincrime.transactions t
	    ,fincrime.account a
	WHERE t.reciever_acct=a.acct_id 
    --Where senders account risk is high
	and t.send_country_risk ='High'
	and a.acct_risk= 'High'
	-- Money is flowing through high risk country to low risk country
	and t.reciever_country_risk ='Low'
	GROUP BY t.sender_acct
		,t.reciever_acct 
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
		-- Money recieved in the account is more than the stated annual income of an account
		having sum(t.transaction_amt) > a.acct_annual_income 
		order by transaction_amt desc