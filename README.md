# Bank Database Management System (BDBMS)

This repository contains an academic Bank Database Management System designed using relational database principles and implemented in Oracle SQL.

The system models real-world banking operations including customer management, account handling, transactions, loans, and fixed deposits, with strong emphasis on data integrity, auditability, and authorization at the database level.

---

## Key Features

- Ledger-based transaction system (immutable transaction history)
- Dynamic balance calculation from transaction ledger
- Role-based access control (Manager, Teller, etc.)
- Branch-level authorization enforcement
- Normalized relational schema (up to BCNF)
- Database-level business rule enforcement using:
  - Constraints
  - Functions
  - Procedures
  - Triggers
- Audit-friendly design aligned with real banking systems

---

## Design Philosophy

Instead of storing account balances directly, this system derives balances dynamically from an append-only transaction ledger. This design ensures:

- Strong audit trails
- Prevention of update anomalies
- Accurate reconstruction of financial state
- Alignment with real-world banking practices

All critical business rules are enforced at the database level rather than relying solely on application logic.

---

## Technologies Used

- Oracle Database 11g XE
- SQL / PL/SQL
- Relational Database Design
- ER Modeling and Normalization

---

## Project Structure

- `schema/` – table definitions, keys, and constraints
- `functions/` – reusable database functions
- `procedures/` – business logic and transactional operations
- `triggers/` – integrity and authorization enforcement
- `views/` – reporting and abstraction layers
- `docs/` – project report and documentation

---

## Academic Context

This project was developed as part of a **Database Systems** course to demonstrate practical application of relational modeling, normalization, and database-level enforcement of business rules.

---

## Disclaimer

This project is intended for educational purposes only and does not represent a production-ready banking system.
