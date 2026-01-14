CREATE TABLE statements:
1.USER_ROLE
CREATE TABLE USER_ROLE (
    role_id     NUMBER(3),
    role_name   VARCHAR2(20) NOT NULL,

    CONSTRAINT pk_user_role PRIMARY KEY (role_id),
    CONSTRAINT uk_user_role_name UNIQUE (role_name)
);

________________________________________
2.BRANCH
CREATE TABLE BRANCH (
    branch_id       NUMBER(5),
    branch_code     VARCHAR2(10) NOT NULL,
    branch_name     VARCHAR2(50) NOT NULL,
    branch_address  VARCHAR2(150) NOT NULL,
    branch_city     VARCHAR2(30) NOT NULL,
    branch_phone    VARCHAR2(15),

    CONSTRAINT pk_branch PRIMARY KEY (branch_id),
    CONSTRAINT uk_branch_code UNIQUE (branch_code),
    CONSTRAINT uk_branch_phone UNIQUE (branch_phone)
);

________________________________________
3️.ACCOUNT_TYPE
CREATE TABLE ACCOUNT_TYPE (
    account_type_id  NUMBER(3),
    type_name        VARCHAR2(20) NOT NULL,
    description      VARCHAR2(100),

    CONSTRAINT pk_account_type PRIMARY KEY (account_type_id),
    CONSTRAINT uk_account_type_name UNIQUE (type_name)
);

________________________________________
4️.CUSTOMER
CREATE TABLE CUSTOMER (
    customer_id   NUMBER(10),
    full_name     VARCHAR2(50) NOT NULL,
    cnic          VARCHAR2(15) NOT NULL,
    phone         VARCHAR2(15) NOT NULL,
    email         VARCHAR2(50),
    address       VARCHAR2(150) NOT NULL,

    CONSTRAINT pk_customer PRIMARY KEY (customer_id),
    CONSTRAINT uk_customer_cnic UNIQUE (cnic),
    CONSTRAINT uk_customer_email UNIQUE (email)
);
________________________________________
5️.EMPLOYEE
CREATE TABLE EMPLOYEE (
    employee_id        NUMBER(10),
    full_name          VARCHAR2(50) NOT NULL,
    cnic               VARCHAR2(15) NOT NULL,
    phone              VARCHAR2(15) NOT NULL,
    email              VARCHAR2(50),
    address            VARCHAR2(150) NOT NULL,
    job_title          VARCHAR2(30) NOT NULL,
    salary             NUMBER(10,2) NOT NULL,
    employment_status  VARCHAR2(10) NOT NULL,
    branch_id          NUMBER(5),
    role_id            NUMBER(3),

    CONSTRAINT pk_employee PRIMARY KEY (employee_id),
    CONSTRAINT uk_employee_cnic UNIQUE (cnic),
    CONSTRAINT uk_employee_email UNIQUE (email),
    CONSTRAINT ck_employee_salary CHECK (salary > 0),
    CONSTRAINT ck_employee_status
        CHECK (employment_status IN ('ACTIVE','SUSPENDED','TERMINATED')),
    CONSTRAINT fk_employee_branch
        FOREIGN KEY (branch_id) REFERENCES BRANCH(branch_id),
    CONSTRAINT fk_employee_role
        FOREIGN KEY (role_id) REFERENCES USER_ROLE(role_id)
);
________________________________________
6️.LOGIN_CREDENTIALS
CREATE TABLE LOGIN_CREDENTIALS (
    employee_id    NUMBER(10),
    password_hash  VARCHAR2(255) NOT NULL,

    CONSTRAINT pk_login_credentials PRIMARY KEY (employee_id),
    CONSTRAINT fk_login_employee
        FOREIGN KEY (employee_id)
        REFERENCES EMPLOYEE(employee_id)
        ON DELETE CASCADE
);

________________________________________
7️.ACCOUNT
CREATE TABLE ACCOUNT (
    account_id       NUMBER(12),
    customer_id      NUMBER(10),
    branch_id        NUMBER(5),
    account_type_id  NUMBER(3),
    opening_date     DATE NOT NULL,
    account_status   VARCHAR2(10) NOT NULL,

    CONSTRAINT pk_account PRIMARY KEY (account_id),
    CONSTRAINT ck_account_status
        CHECK (account_status IN ('ACTIVE','FROZEN','CLOSED')),
    CONSTRAINT fk_account_customer
        FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id),
    CONSTRAINT fk_account_branch
        FOREIGN KEY (branch_id) REFERENCES BRANCH(branch_id),
    CONSTRAINT fk_account_type
        FOREIGN KEY (account_type_id) REFERENCES ACCOUNT_TYPE(account_type_id)
);

________________________________________
8️.TRANSACTION_LEDGER
CREATE TABLE TRANSACTION_LEDGER (
    transaction_id            NUMBER(15),
    account_id                NUMBER(12),
    transaction_ref           VARCHAR2(20) NOT NULL,
    transaction_type          VARCHAR2(6) NOT NULL,
    amount                    NUMBER(12,2) NOT NULL,
    purpose                   VARCHAR2(50) NOT NULL,
    created_at                DATE NOT NULL,
   performed_by  NUMBER(10),

    CONSTRAINT pk_transaction_ledger PRIMARY KEY (transaction_id),
    CONSTRAINT ck_tx_type
        CHECK (transaction_type IN ('DEBIT','CREDIT')),
    CONSTRAINT ck_tx_amount
        CHECK (amount > 0),
    CONSTRAINT fk_tx_account
        FOREIGN KEY (account_id) REFERENCES ACCOUNT(account_id),
    CONSTRAINT fk_tx_employee
        FOREIGN KEY (performed_by)
        REFERENCES EMPLOYEE(employee_id)
);
________________________________________
9️.LOAN
CREATE TABLE LOAN (
    loan_id                    NUMBER(10),
    account_id                 NUMBER(12),
    principal_amount           NUMBER(12,2) NOT NULL,
    interest_rate              NUMBER(5,2) NOT NULL,
    start_date                 DATE NOT NULL,
    duration_months            NUMBER(3) NOT NULL,
    loan_status                VARCHAR2(10) NOT NULL,
    approver_id    NUMBER(10),
    approval_date              DATE,

    CONSTRAINT pk_loan PRIMARY KEY (loan_id),
    CONSTRAINT ck_loan_amount CHECK (principal_amount > 0),
    CONSTRAINT ck_loan_rate CHECK (interest_rate > 0),
    CONSTRAINT ck_loan_duration CHECK (duration_months > 0),
    CONSTRAINT ck_loan_status
        CHECK (loan_status IN ('PENDING','ACTIVE','CLOSED','DEFAULTED')),
    CONSTRAINT fk_loan_account
        FOREIGN KEY (account_id) REFERENCES ACCOUNT(account_id),
    CONSTRAINT fk_loan_approved_by
        FOREIGN KEY (approver_id)
        REFERENCES EMPLOYEE(employee_id)
);

________________________________________
10. FIXED_DEPOSIT
CREATE TABLE FIXED_DEPOSIT (
    fd_id                    NUMBER(10),
    account_id               NUMBER(12),
    principal_amount         NUMBER(12,2) NOT NULL,
    interest_rate            NUMBER(5,2) NOT NULL,
    start_date               DATE NOT NULL,
    maturity_months   NUMBER(3) NOT NULL,
    fd_status                VARCHAR2(10) NOT NULL,

    CONSTRAINT pk_fixed_deposit PRIMARY KEY (fd_id),
    CONSTRAINT ck_fd_amount CHECK (principal_amount > 0),
    CONSTRAINT ck_fd_rate CHECK (interest_rate > 0),
    CONSTRAINT ck_fd_maturity CHECK (maturity_months > 0),
    CONSTRAINT ck_fd_status
        CHECK (fd_status IN ('ACTIVE','MATURED','CLOSED')),
    CONSTRAINT fk_fd_account
        FOREIGN KEY (account_id) REFERENCES ACCOUNT(account_id)
);
