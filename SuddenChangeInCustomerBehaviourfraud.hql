/* HQL script will detect sudden change in behaviour for an account
   where daily ATM transaction count is greater than monthly average ATM transaction 
   count or transaction amount
*/
WITH temp_data
AS (
	SELECT count(t.transaction_id) AS transaction_ct -- Daily transaction Count
		,sum(t.transaction_amt) AS transaction_amt
		,t.sender_acct
		,t.transaction_date
	FROM fincrime.transactions t
	WHERE t.transaction_type = 'debit-card' -- For Debit Card
	GROUP BY t.sender_acct
		,t.transaction_date
	)
	,fraud_rec
AS (
	SELECT a.acct_id AS AcctID
		,a.acct_name AS AcctName
		,CASE 
			WHEN (td.transaction_ct > a.avg_monthly_atm_ct or td.transaction_amt > a.avg_monthly_atm_amt) -- When Daily transaction ct > than monthly avg ct
				THEN 'Y'
			ELSE 'N'
			END Potential_fraud_fl -- Fraud Flag
		,a.acct_risk
		,a.avg_monthly_atm_ct AS Monthly_Avg_ATM_trans_ct
		,td.transaction_ct AS Daily_ATM_Tran_Ct
		,a.avg_monthly_atm_amt AS Monthly_Avg_ATM_trans_amt
		,td.transaction_amt AS Daily_ATM_Tran_Amt
		,td.transaction_ct AS Daily_transaction_ct
		,a.acct_annual_income AS Annual_Income
		,a.acct_src_of_income AS Income_Source
		,a.avg_monthly_creditcard_spent
		,a.avg_monthly_dep_amt
		,a.avg_monthly_withdrawl_amt
		,td.*
	FROM temp_data td
		,account a
	WHERE td.sender_acct = a.acct_id
	)
SELECT *
FROM fraud_rec f
WHERE f.Potential_fraud_fl = 'Y'
ORDER BY f.Daily_transaction_ct DESC;
