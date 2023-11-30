/*REQUIREMENTS
Create the bank code by splitting out off the letters from the Transaction code, call this field 'Bank'
Change transaction date to the just be the month of the transaction
Total up the transaction values so you have one row for each bank and month combination
Rank each bank for their value of transactions each month against the other banks. 1st is the highest value of transactions, 3rd the lowest. 
Without losing all of the other data fields, find:
The average rank a bank has across all of the months, call this field 'Avg Rank per Bank'
The average transaction value per rank, call this field 'Avg Transaction Value per Rank'
*/
--Table_Overview
SELECT * 
    FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK01;

--1
WITH cte AS
(
SELECT split_part(transaction_code,'-','1') AS bank
      ,monthname(date(transaction_date, 'dd/MM/yyyy hh24:mi:ss')) AS date_month
      ,sum(value) AS amount
      ,rank() over (partition BY date_month ORDER BY amount DESC) AS rnk
    FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK01
    GROUP BY 1,2
)
,cte1 AS 
(
SELECT bank
      ,avg(rnk) AS average_rank_per_bank
    FROM cte
    GROUP BY 1
)
,cte2 AS 
(
SELECT rnk
      ,avg(amount) AS average_tarnsaction_value_per_bank
    FROM cte
    GROUP BY 1
)      
SELECT cte.*
       ,average_rank_per_bank
       ,average_tarnsaction_value_per_bank
    FROM cte
    JOIN cte1 ON cte.bank=cte1.bank
    JOIN cte2 ON cte.rnk=cte2.rnk;
