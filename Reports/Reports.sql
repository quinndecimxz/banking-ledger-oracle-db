1.Shows customer, account, branch, and current balance:
SELECT c.customer_id, c.full_name AS customer_name, a.account_id, b.branch_code, b.branch_name, get_account_balance(a.account_id) AS current_balance
FROM CUSTOMER c JOIN ACCOUNT a ON c.customer_id = a.customer_id JOIN BRANCH b ON a.branch_id = b.branch_id ORDER BY c.customer_id;

2.TRANSACTION STATEMENT FOR A GIVEN ACCOUNT:
SELECT t.transaction_id, t.transaction_ref, t.transaction_type, t.amount, t.purpose, t.created_at FROM TRANSACTION_LEDGER t WHERE t.account_id = 30001
ORDER BY t.created_at;

3. Pending loans:
SELECT l.loan_id, c.full_name AS customer_name, b.branch_code, l.principal_amount, l.duration_months, l.start_date FROM LOAN l JOIN ACCOUNT a
ON l.account_id = a.account_id JOIN CUSTOMER c ON a.customer_id = c.customer_id JOIN BRANCH b ON a.branch_id = b.branch_id WHERE l.loan_status = 'PENDING';

4. Transactions per employee:
SELECT e.employee_id, e.full_name AS employee_name, b.branch_code, COUNT(t.transaction_id) AS transactions_handled FROM EMPLOYEE e 
LEFT JOIN TRANSACTION_LEDGER t ON e.employee_id = t.performed_by JOIN BRANCH b ON e.branch_id = b.branch_id GROUP BY e.employee_id, e.full_name, b.branch_code 
ORDER BY transactions_handled DESC;

5. Customer Categorization Based on Total Balance
SELECT c.customer_id, c.full_name AS customer_name, SUM(get_account_balance(a.account_id)) 
AS total_balance, CASE WHEN SUM(get_account_balance(a.account_id)) >= 100000 THEN 'HIGH VALUE' WHEN SUM(get_account_balance(a.account_id)) 
BETWEEN 50000 AND 99999 THEN 'MEDIUM VALUE' ELSE 'LOW VALUE' END AS customer_category FROM CUSTOMER c JOIN ACCOUNT a ON c.customer_id = a.customer_id 
GROUP BY c.customer_id, c.full_name HAVING SUM(get_account_balance(a.account_id)) > 0 ORDER BY total_balance DESC;

6. Account Activity Classification
SELECT a.account_id, c.full_name AS customer_name, b.branch_code, tx.txn_count, CASE WHEN tx.txn_count >= 5 
THEN 'HIGH ACTIVITY' WHEN tx.txn_count BETWEEN 2 AND 4 THEN 'MODERATE ACTIVITY' ELSE 'LOW ' END AS activity_status FROM ACCOUNT a JOIN CUSTOMER c 
ON a.customer_id = c.customer_id JOIN BRANCH b ON a.branch_id = b.branch_id LEFT JOIN (SELECT account_id, COUNT(*) AS txn_count FROM TRANSACTION_LEDGER 
GROUP BY account_id) tx ON a.account_id = tx.account_id
ORDER BY activity_status, a.account_id;
