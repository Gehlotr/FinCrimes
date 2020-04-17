-- Transaction table structure
                CREATE EXTERNAL TABLE `bigdataproject`.`transactions`
                 (
  `transaction_id` bigint ,
  `transaction_type` string ,
  `transaction_amt` bigint ,
  `transaction_date` string ,
  `sender_acct` string ,
  `sender_acct_name` string ,
  `send_country_name` string ,
  `send_country_cd` string ,
  `send_country_risk` string ,
  `reciever_acct` string ,
  `reciever_acct_name` string ,
  `reciever_country_name` string ,
  `reciever_country_cd` string ,
  `reciever_country_risk` string ,
  `overall_transaction_risk` string ) ROW FORMAT   DELIMITED
    FIELDS TERMINATED BY ','
    COLLECTION ITEMS TERMINATED BY '\002'
    MAP KEYS TERMINATED BY '\003'
   STORED AS TextFile LOCATION 's3a://bigdatafincrimedatalake/aws_dataset.csv_table/Transactions.csv_table'
   TBLPROPERTIES("skip.header.line.count" = "1")

---- Account Table structure  
CREATE EXTERNAL TABLE `bigdataproject`.`account`
(
  `acct_id` string ,
  `acct_name` string ,
  `acct_open_dt` string ,
  `Acct_Type` string ,
  `acct_email` string ,
  `acct_phone` bigint ,
  `acct_src_of_income` string ,
  `acct_industry` string ,
  `acct_risk` string ,
  `acct_annual_income` bigint ,
  `avg_monthly_atm_amt` bigint ,
  `avg_monthly_atm_ct` bigint ,
  `avg_monthly_creditcard_spent` bigint ,
  `avg_monthly_dep_amt` double ,
  `avg_monthly_withdrawl_amt` double ) ROW FORMAT   DELIMITED
    FIELDS TERMINATED BY ','
    COLLECTION ITEMS TERMINATED BY '\002'
    MAP KEYS TERMINATED BY '\003'
  STORED AS TextFile LOCATION 's3a://bigdatafincrimedatalake/Test_act_data_aws.csv_table/Account.csv_table'
TBLPROPERTIES("skip.header.line.count" = "1")
