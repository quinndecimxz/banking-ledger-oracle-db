Functions:
Function 1
 get_account_balance:
CREATE OR REPLACE FUNCTION get_account_balance (
    p_account_id IN ACCOUNT.account_id%TYPE
) RETURN NUMBER
IS
    v_balance NUMBER;
BEGIN
    SELECT NVL(
        SUM(
            CASE
                WHEN transaction_type = 'CREDIT' THEN amount
                WHEN transaction_type = 'DEBIT'  THEN -amount
            END
        ), 0
    )
    INTO v_balance
    FROM TRANSACTION_LEDGER
    WHERE account_id = p_account_id;

    RETURN v_balance;
END;
TEST:
SELECT get_account_balance(30001) AS balance
FROM dual;
Function 2 
get_employee_role
CREATE OR REPLACE FUNCTION get_employee_role (
    p_employee_id IN EMPLOYEE.employee_id%TYPE
) RETURN USER_ROLE.role_name%TYPE
IS
    v_role USER_ROLE.role_name%TYPE;
BEGIN
    SELECT r.role_name
    INTO v_role
    FROM EMPLOYEE e
    JOIN USER_ROLE r
        ON e.role_id = r.role_id
    WHERE e.employee_id = p_employee_id;

    RETURN v_role;
END;

Function 3 
is_employee_active:

CREATE OR REPLACE FUNCTION is_employee_active (
    p_employee_id IN EMPLOYEE.employee_id%TYPE
) RETURN BOOLEAN
IS
    v_status EMPLOYEE.employment_status%TYPE;
BEGIN
    SELECT employment_status
    INTO v_status
    FROM EMPLOYEE
    WHERE employee_id = p_employee_id;

    RETURN v_status = 'ACTIVE';
END;

FUNCTION 4 
is_account_active:
CREATE OR REPLACE FUNCTION is_account_active (
    p_account_id IN ACCOUNT.account_id%TYPE
) RETURN BOOLEAN
IS
    v_status ACCOUNT.account_status%TYPE;
BEGIN
    SELECT account_status
    INTO v_status
    FROM ACCOUNT
    WHERE account_id = p_account_id;

    RETURN v_status = 'ACTIVE';
END;

FUNCTION 5
 get_account_branch:
CREATE OR REPLACE FUNCTION get_account_branch (
    p_account_id IN ACCOUNT.account_id%TYPE
) RETURN BRANCH.branch_id%TYPE
IS
    v_branch_id BRANCH.branch_id%TYPE;
BEGIN
    SELECT branch_id
    INTO v_branch_id
    FROM ACCOUNT
    WHERE account_id = p_account_id;

    RETURN v_branch_id;
END;

FUNCTION 6 
is_employee_manager:
CREATE OR REPLACE FUNCTION is_employee_manager (
    p_employee_id IN EMPLOYEE.employee_id%TYPE
) RETURN BOOLEAN
IS
    v_role USER_ROLE.role_name%TYPE;
BEGIN
    v_role := get_employee_role(p_employee_id);
    RETURN v_role = 'MANAGER';
END;
