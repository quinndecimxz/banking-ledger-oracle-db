PROCEDURES:
PROCEDURE 1: create_employee
CREATE OR REPLACE PROCEDURE create_employee (
    p_full_name    IN EMPLOYEE.full_name%TYPE,
    p_cnic         IN EMPLOYEE.cnic%TYPE,
    p_phone        IN EMPLOYEE.phone%TYPE,
    p_email        IN EMPLOYEE.email%TYPE,
    p_address      IN EMPLOYEE.address%TYPE,
    p_job_title    IN EMPLOYEE.job_title%TYPE,
    p_salary       IN EMPLOYEE.salary%TYPE,
    p_branch_id    IN EMPLOYEE.branch_id%TYPE,
    p_role_id      IN EMPLOYEE.role_id%TYPE
)
IS
BEGIN
    INSERT INTO EMPLOYEE (
        employee_id,
        full_name,
        cnic,
        phone,
        email,
        address,
        job_title,
        salary,
        employment_status,
        branch_id,
        role_id
    )
    VALUES (
        NULL,
        p_full_name,
        p_cnic,
        p_phone,
        p_email,
        p_address,
        p_job_title,
        p_salary,
        'ACTIVE',
        p_branch_id,
        p_role_id
    );

    COMMIT;
END;

TEST:
BEGIN
    create_employee(
        p_full_name => 'Test Employee2',
        p_cnic      => '35202-98765433-1',
        p_phone     => '03111222332',
        p_email     => 'test.employee2@email.com',
        p_address   => 'MULTAN',
P_JOB_TITLE => 'TELLER',
P_SALARY => 20000,
        p_branch_id => 101,
        p_role_id   => 1  -- e.g. TELLER / MANAGER
       
    );
END;

PROCEDURE 2: create_customer
CREATE OR REPLACE PROCEDURE create_customer (
    p_full_name IN CUSTOMER.full_name%TYPE,
    p_cnic      IN CUSTOMER.cnic%TYPE,
    p_phone     IN CUSTOMER.phone%TYPE,
    p_email     IN CUSTOMER.email%TYPE,
    p_address   IN CUSTOMER.address%TYPE
)
IS
BEGIN
    INSERT INTO CUSTOMER (
        customer_id,
        full_name,
        cnic,
        phone,
        email,
        address
    )
    VALUES (
        NULL,
        p_full_name,
        p_cnic,
        p_phone,
        p_email,
        p_address
    );

    COMMIT;
END;
TEST:
BEGIN
    create_customer(
        p_full_name => 'Test Customer',
        p_cnic      => '35202-1234567-9',
        p_phone     => '03001234567',
        p_email     => 'test.customer@email.com',
        p_address   => 'Lahore'
    );
END;
PROCEDURE 3: create_account

CREATE OR REPLACE PROCEDURE create_account (
    p_customer_id     IN ACCOUNT.customer_id%TYPE,
    p_branch_id       IN ACCOUNT.branch_id%TYPE,
    p_account_type_id IN ACCOUNT.account_type_id%TYPE
)
IS
BEGIN
    INSERT INTO ACCOUNT (
        account_id,
        customer_id,
        branch_id,
        account_type_id,
        opening_date,
        account_status
    )
    VALUES (
        NULL,
        p_customer_id,
        p_branch_id,
        p_account_type_id,
        SYSDATE,
        'ACTIVE'
    );

    COMMIT;
END;
TEST
BEGIN
    create_account(
        p_customer_id => 10001,
        p_branch_id   => 101,
        p_account_type_id => 2
    );
END;

PROCEDURE 4: deposit money
CREATE OR REPLACE PROCEDURE deposit_money (
    p_account_id  IN ACCOUNT.account_id%TYPE,
    p_amount      IN NUMBER,
    p_employee_id IN EMPLOYEE.employee_id%TYPE
) IS
    v_branch_code BRANCH.branch_code%TYPE;
    v_ref_no      NUMBER;
    v_txn_ref     TRANSACTION_LEDGER.transaction_ref%TYPE;
BEGIN
    -- Get branch code
    SELECT b.branch_code
    INTO v_branch_code
    FROM ACCOUNT a
    JOIN BRANCH b ON a.branch_id = b.branch_id
    WHERE a.account_id = p_account_id;

    -- Generate transaction reference
    v_ref_no  := TRANSFER_REF_SEQ.NEXTVAL;
    v_txn_ref := 'TXN-' || v_branch_code || '-' || v_ref_no;

    -- Insert credit entry
    INSERT INTO TRANSACTION_LEDGER (
        account_id,
        transaction_ref,
        transaction_type,
        amount,
        purpose,
        performed_by
    ) VALUES (
        p_account_id,
        v_txn_ref,
        'CREDIT',
        p_amount,
        'Cash Deposit',
        p_employee_id
    );
END;
TEST
BEGIN
    deposit_money(30001, 10000, 20000);
END;

PROCEDURE 5: withdraw money
CREATE OR REPLACE PROCEDURE withdraw_money (
    p_account_id  IN ACCOUNT.account_id%TYPE,
    p_amount      IN NUMBER,
    p_employee_id IN EMPLOYEE.employee_id%TYPE
) IS
    v_balance     NUMBER;
    v_branch_code BRANCH.branch_code%TYPE;
    v_ref_no      NUMBER;
    v_txn_ref     TRANSACTION_LEDGER.transaction_ref%TYPE;
BEGIN
    -- Balance check
    v_balance := get_account_balance(p_account_id);
    IF v_balance < p_amount THEN
        RAISE_APPLICATION_ERROR(-20002, 'Insufficient balance');
    END IF;

    -- Get branch code
    SELECT b.branch_code
    INTO v_branch_code
    FROM ACCOUNT a
    JOIN BRANCH b ON a.branch_id = b.branch_id
    WHERE a.account_id = p_account_id;

    -- Generate tansaction reference
    v_ref_no  := TRANSFER_REF_SEQ.NEXTVAL;
    v_txn_ref := 'TXN-' || v_branch_code || '-' || v_ref_no;

    -- Insert debit entry
    INSERT INTO TRANSACTION_LEDGER (
        account_id,
        transaction_ref,
        transaction_type,
        amount,
        purpose,
        performed_by
    ) VALUES (
        p_account_id,
        v_txn_ref,
        'DEBIT',
        p_amount,
        'Cash Withdrawal',
        p_employee_id
    );
END;
TEST
BEGIN
    withdraw_money(30001, 3000, 20000);
END;


PROCEDURE 6: Transfer money
CREATE OR REPLACE PROCEDURE transfer_money (
    p_from_account IN ACCOUNT.account_id%TYPE,
    p_to_account   IN ACCOUNT.account_id%TYPE,
    p_amount       IN NUMBER,
    p_employee_id  IN EMPLOYEE.employee_id%TYPE
) IS
    v_balance     NUMBER;
    v_branch_code BRANCH.branch_code%TYPE;
    v_ref_no      NUMBER;
    v_txn_ref     TRANSACTION_LEDGER.transaction_ref%TYPE;
BEGIN
    -- Balance check
    v_balance := get_account_balance(p_from_account);
    IF v_balance < p_amount THEN
        RAISE_APPLICATION_ERROR(-20001, 'Insufficient balance');
    END IF;

    --  Surce branch code
    SELECT b.branch_code
    INTO v_branch_code
    FROM ACCOUNT a
    JOIN BRANCH b ON a.branch_id = b.branch_id
    WHERE a.account_id = p_from_account;

    -- one logical reference for the transfer
    v_ref_no  := TRANSFER_REF_SEQ.NEXTVAL;
    v_txn_ref := 'TXN-' || v_branch_code || '-' || v_ref_no;

    -- debit
    INSERT INTO TRANSACTION_LEDGER (
        account_id, transaction_ref, transaction_type,
        amount, purpose, performed_by
    ) VALUES (
        p_from_account, v_txn_ref, 'DEBIT',
        p_amount, 'Transfer Out', p_employee_id
    );

    --  credit
    INSERT INTO TRANSACTION_LEDGER (
        account_id, transaction_ref, transaction_type,
        amount, purpose, performed_by
    ) VALUES (
        p_to_account, v_txn_ref, 'CREDIT',
        p_amount, 'Transfer In', p_employee_id
    );
END;
TEST
BEGIN
    transfer_money(30001, 30003, 5000, 20000);
END;

PROCEDURE 7: approve_loan
CREATE OR REPLACE PROCEDURE approve_loan (
    p_loan_id    IN LOAN.loan_id%TYPE,
    p_manager_id IN EMPLOYEE.employee_id%TYPE
)
IS
    v_manager_role_id USER_ROLE.role_id%TYPE;
    v_emp_role_id     EMPLOYEE.role_id%TYPE;
    v_manager_branch  EMPLOYEE.branch_id%TYPE;
    v_loan_branch     ACCOUNT.branch_id%TYPE;
    v_status          LOAN.loan_status%TYPE;
BEGIN
   
    SELECT role_id
    INTO v_manager_role_id
    FROM USER_ROLE
    WHERE role_name = 'MANAGER';

    
    SELECT role_id, branch_id
    INTO v_emp_role_id, v_manager_branch
    FROM EMPLOYEE
    WHERE employee_id = p_manager_id
      AND employment_status = 'ACTIVE';

    
    IF v_emp_role_id <> v_manager_role_id THEN
        RAISE_APPLICATION_ERROR(
            -20000,
            'Only branch manager can approve loan'
        );
    END IF;

    
    SELECT l.loan_status, a.branch_id
    INTO v_status, v_loan_branch
    FROM LOAN l
    JOIN ACCOUNT a ON l.account_id = a.account_id
    WHERE l.loan_id = p_loan_id;

    
    IF v_status <> 'PENDING' THEN
        RAISE_APPLICATION_ERROR(
            -20000,
            'Loan is not in pending state'
        );
    END IF;


    IF v_manager_branch <> v_loan_branch THEN
        RAISE_APPLICATION_ERROR(
            -20000,
            'Manager cannot approve loan of another branch'
        );
    END IF;

    
    UPDATE LOAN
    SET loan_status   = 'APPROVED',
        approver_id   = p_manager_id,
        approval_date = SYSDATE
    WHERE loan_id = p_loan_id;

    COMMIT;
END;
