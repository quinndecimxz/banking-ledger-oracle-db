Primary Keys:
Table	Primary Key
BRANCH	branch_id
CUSTOMER	customer_id
USER_ROLE	role_id
EMPLOYEE	employee_id
ACCOUNT_TYPE	account_type_id
ACCOUNT	account_id
TRANSACTION	transaction_id
LOAN	loan_id
FIXED_DEPOSIT	fd_id
LOGIN_CREDENTIALS	employee_id

Foreign Key mappings:
ACCOUNT:
•	ACCOUNT.customer_id  CUSTOMER.customer_id
•	ACCOUNT.branch_id  BRANCH.branch_id
•	ACCOUNT.account_type_id  ACCOUNT_TYPE.account_type_id

EMPLOYEE:
•	EMPLOYEE.branch_id  BRANCH.branch_id
•	EMPLOYEE.role_id  USER_ROLE.role_id
LOGIN_CRENTIALS:
•	LOGIN_CREDENTIALS.employee_id  EMPLOYEE.employee_id

TRANSACTION:
•	TRANSACTION.account_id  ACCOUNT.account_id
•	TRANSACTION.performed_by  EMPLOYEE.employee_id

LOAN:
•	LOAN.account_id  ACCOUNT.account_id
•	LOAN.customer_id  CUSTOMER.customer_id

FIXED_DEPOSIT:
•	FIXED_DEPOSIT.account_id  ACCOUNT.account_id
•	FIXED_DEPOSIT.customer_id  CUSTOMER.customer_id

Candidate Keys:
CUSTOMER	cnic
EMPLOYEE	employee_cnic (if stored)
USER_ROLE	role_name
ACCOUNT_TYPE	type_name
LOGIN_CREDENTIALS	employee_id

Alternate Keys (AK):
CUSTOMER	cnic
USER_ROLE	role_name
ACCOUNT_TYPE	type_name
