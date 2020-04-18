/* 
-- Potential Lost or Stolen cretdit card - Unusual card spent 
HQL script will detect sudden change in behaviour for an account
   where daily credit card spent is unusally high by a certain percentage of your
   average monthly spent. Unusual activities or anamolous transctions must sent alerts 
   to a customer to check the validity of the transactions and post authentication these 
   transactions must be cleared.
*/
WITH temp_data
AS (
	SELECT count(t.transaction_id) AS transaction_ct -- Daily transaction Count
		,sum(t.transaction_amt) AS transaction_amt
		,t.sender_acct
		,t.transaction_date
	FROM fincrime.transactions t
	WHERE t.transaction_type = 'credit-card' -- For Credit Card
	GROUP BY t.sender_acct
		,t.transaction_date
		having sum(t.transaction_amt) > 500
		order by transaction_amt desc
	)
	,fraud_rec
AS (
	SELECT a.acct_id AS AcctID
		,a.acct_name AS AcctName
		-- When daily credit card spent is more than two times of avg monthly spent
		,CASE 
			WHEN ((td.transaction_amt/avg_monthly_creditcard_spent) > 2)  
				THEN 'Y'
			ELSE 'N'
			END Potential_fraud_fl -- Fraud Flag
		, (td.transaction_amt/avg_monthly_creditcard_spent) AS incr_in_credit_card_spent
		,a.acct_risk
		,td.transaction_ct AS Daily_credit_card_transaction_ct
		,td.transaction_amt AS Daily_credit_card_transaction_amt
		,a.avg_monthly_creditcard_spent
		,a.acct_annual_income AS Annual_Income
		,a.acct_src_of_income AS Income_Source
		,a.avg_monthly_dep_amt
		,a.avg_monthly_withdrawl_amt
		,td.*
	FROM temp_data td
		,account a
    -- Tracking only where money is going out from an account
	WHERE td.sender_acct = a.acct_id
	)
SELECT f.AcctID
,f.AcctName
,f.Potential_fraud_fl
,f.incr_in_credit_card_spent
,a.avg_monthly_creditcard_spent	
,Daily_credit_card_transaction_amt
,Daily_credit_card_transaction_ct
FROM fraud_rec f
WHERE f.Potential_fraud_fl = 'Y'
ORDER BY f.incr_in_credit_card_spent DESC;