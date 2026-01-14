View customer account
CREATE OR REPLACE VIEW vw_customer_accounts AS
SELECT c.customer_id, c.full_name AS customer_name,c.cnic,c.phone,c.email,a.account_id,a.account_status,a.opening_date,
b.branch_code,b.branch_name,b.branch_city FROM CUSTOMER c JOIN ACCOUNT a ON c.customer_id = a.customer_id JOIN BRANCH b ON a.branch_id = b.branch_id;

LOAN DETAILS
CREATE OR REPLACE VIEW vw_loan_details AS SELECT 
l.loan_id, l.account_id, c.customer_id, 
c.full_name AS customer_name, b.branch_code, b.branch_name, l.principal_amount, l.interest_rate, l.duration_months, l.loan_status, l.approval_date,
e.employee_id AS approver_id, e.full_name AS approver_name FROM LOAN l JOIN ACCOUNT a ON l.account_id = a.account_id JOIN CUSTOMER c ON a.customer_id = c.customer_id
JOIN BRANCH b ON a.branch_id = b.branch_id LEFT JOIN EMPLOYEE e ON l.approver_id = e.employee_id;

TRANSACTION HISTORY:
CREATE OR REPLACE VIEW vw_transaction_history AS SELECT t.transaction_id,
t.transaction_ref, t.account_id,c.full_name AS customer_name, t.transaction_type,t.amount, 
t.purpose,t.created_at,e.full_name AS performed_by FROM TRANSACTION_LEDGER t JOIN ACCOUNT a ON t.account_id = a.account_id JOIN CUSTOMER c ON a.customer_id = .customer_id
LEFT JOIN EMPLOYEE e ON t.performed_by = e.employee_id;
