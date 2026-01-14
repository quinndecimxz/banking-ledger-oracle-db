1. TRANSACTION LEDGER IMMUTABILITY TRIGGER
Financial transactions must never be updated or deleted:
CREATE OR REPLACE TRIGGER trg_ledger_immutable
BEFORE UPDATE OR DELETE ON TRANSACTION_LEDGER
BEGIN
    RAISE_APPLICATION_ERROR(
        -20000,
        'Transactions are immutable and cannot be modified or deleted'
    );
END;

2. ACCOUNT STATUS PROTECTION TRIGGER
NO TRANSACTION ON INACTIVE ACCOUNTS:
CREATE OR REPLACE TRIGGER trg_block_inactive_account
BEFORE INSERT ON TRANSACTION_LEDGER
FOR EACH ROW
DECLARE
    v_status ACCOUNT.account_status%TYPE;
BEGIN
    SELECT account_status
    INTO v_status
    FROM ACCOUNT
    WHERE account_id = :NEW.account_id;

    IF v_status <> 'ACTIVE' THEN
        RAISE_APPLICATION_ERROR(
            -20000,
            'Transactions are not allowed on inactive accounts'
        );
    END IF;
END;

3. EMPLOYEE STATUS PROTECTION TRIGGER
Inactive employees cannot perform transactions:
CREATE OR REPLACE TRIGGER trg_block_inactive_employee
BEFORE INSERT ON TRANSACTION_LEDGER
FOR EACH ROW
DECLARE
    v_status EMPLOYEE.employment_status%TYPE;
BEGIN
    SELECT employment_status
    INTO v_status
    FROM EMPLOYEE
    WHERE employee_id = :NEW.performed_by;

    IF v_status <> 'ACTIVE' THEN
        RAISE_APPLICATION_ERROR(
            -20000,
            'Inactive employee cannot perform transactions'
        );
    END IF;
END;
4. TRIGGER FOR AUTOMATIC_ID_GENERATION
CREATE OR REPLACE TRIGGER TRG_TRANSACTION_LEDGER_ID
BEFORE INSERT ON TRANSACTION_LEDGER
FOR EACH ROW
BEGIN
    IF :NEW.transaction_id IS NULL THEN
        :NEW.transaction_id := TRANSACTION_LEDGER_ID_SEQ.NEXTVAL;
    END IF;

    IF :NEW.created_at IS NULL THEN
        :NEW.created_at := SYSDATE;
    END IF;
END;
