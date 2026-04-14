# Diagram Content Standards

This document defines content-level standards for each diagram type (business/logical level, not XML).

---

## I. ER Diagram Content

### Table Classification (4 Layers)

| Layer | Role | Examples | Position |
|-------|------|---------|---------|
| L1 Base | Account / Person / Role | User, Admin, Role | Top-left |
| L2 Business | Core business entity | Product, Order, Post | Center |
| L3 Detail |附属/明细 data | OrderItem, CartItem, Review | Right / Bottom |
| L4 Config | Dictionary / Rules / Tags | Category, Coupon, Tag, Permission | Bottom-right edge |

### Primary Key Standard

```
Prefer BIGINT auto-increment (best performance)
Never use UUID/varchar as primary key
Naming: {entity}_id  BIGINT PK
```

### Audit Fields (Required per table)

```sql
created_at  DATETIME    -- creation timestamp
updated_at  DATETIME    -- last update timestamp
Optional: deleted_at DATETIME  -- soft delete
```

### Field Naming Conventions

| Type | Prefix/Suffix | Example |
|------|--------------|---------|
| Primary key | `{entity}_id` | user_id, order_id |
| Foreign key | `{entity}_id` | category_id, sku_id |
| Amount | `_amount` | total_amount, discount_amount |
| Unit price | `_price` | price, original_price |
| Count | `_count` / `_quantity` | sales_count, quantity |
| Status | `status` / `is_xxx` | status, is_active, is_deleted |
| Code/Number | `_no` / `_code` | order_no, coupon_code |
| Timestamp | `_time` / `_at` | pay_time, created_at |
| Media/JSON | plain | images, specs, extra |

### Relationship Decision

```
1:N  — one A has many B (Address belongs to User, Order belongs to User)
1:1  — one-to-one (User table and UserProfile table)
N:N  — many-to-many (User favorites Product, Role has Permission)
       → must use junction table
Self — tree structure (Category.parent_id references itself)
```

### Junction Table Standard

```sql
UserFavorite(user_id, product_id, created_at)
RolePermission(role_id, permission_id)
```

### Order Amount Chain

```
total_amount    = sum of original item prices
discount_amount = coupon + campaign discounts
freight_amount  = shipping cost
pay_amount      = total_amount - discount_amount + freight_amount
```

---

## II. Use Case Diagram Content

### Actor Naming

- Use role names, not individual person names
- Format: `noun` (User, Admin, Guest)
- Each Actor must associate with at least 1 UseCase

### UseCase Naming

- Use verb-object phrase: `View Product Detail`, `Submit Order`
- One complete action per UseCase
- Recommended count: 2~6 per Actor (split if too many, consider subsystems)

### Include / Extend / Generalization Decision

```
Include  — behavior of one UC necessarily includes another
           e.g., "Login" include "Verify Captcha"
           → Login must verify captcha to complete

Extend   — extends another UC under specific conditions
           e.g., "Review" extend "Append Review"
           → Append Review only happens when user wants to add more

Generalization — child UC inherits and specializes parent
           e.g., "Admin Login" generalizes "Login"
```

### UseCase Description Template (optional)

```
UC-ID:   Title
Actor:   Primary Actor
Precondition:
Basic Flow: 1.  2.  3.
Postcondition:
```

---

## III. Sequence Diagram Content

### Participant Selection

- Real actors: Actor / User
- System components: Frontend, MobileApp, BackendService, ExternalSystem
- Data stores: DB, Cache, MQ

### Message Naming

```
Request:  verb phrase (loginRequest, queryProduct)
Return:   noun or status (token, productList)
          omit if self-evident
```

### Self-Call Annotation

```
nest1: methodA()  ← complete method name with parentheses
      ├── 1. nestedMethod()
      └── 2. recursiveCall()  label "recursive"
```

### Arrow Style Reference

| Message Type | Arrow Style | Line |
|-------------|------------|------|
| Sync request | Filled triangle | Solid |
| Async request | Hollow triangle | Solid |
| Return | Hollow triangle | Dashed |
| Self-call | Hollow triangle | Dashed (nested) |

---

## IV. Flowchart Content

### Node Naming Rules

```
Start/End:  brief phrase (Start, End, Success, Failure)
Activity:   verb-object phrase (Place Order, Review Request, Ship)
Decision:   yes/no question (Passed?, Sufficient Stock?)
```

### Decision Branch Labels

- Every branch must be labeled `Yes/Y/True` or `No/N/False`
- Labels go beside arrows, not inside the diamond

### Branch Merge Patterns

```
DecisionA ──Yes──▶ ActivityB
                       │
                       ▼
DecisionC ◀──No─── ActivityD
```

---

## V. Universal Layout Principles

### Direction Priority

```
Primary: left→right  >  top→bottom
- Flowchart/Sequence: horizontal first
- ER: dependency flows left→right
- Use Case: Actor left, UseCase right
```

### Alignment

```
Same-column elements: left-aligned (or right-aligned), uniform spacing
Grid layout: all elements occupy grid nodes
Avoid diagonal edges: all edges horizontal or vertical
```

### Spacing Standards

| Element Relationship | Minimum Gap |
|---------------------|------------|
| Same-column adjacent elements | 40px |
| Different-column elements | 60px |
| Decision to branch nodes | 60px |
| Between Actors | 60px |
| Between UseCases | 30px |

### Semantic Colors (Optional)

| Color | Semantic |
|-------|---------|
| Green node | Success / Pass / Start |
| Red node | Failure / End / Error |
| Blue border | Input / External system |
| Yellow fill | Decision / Review node |
| Light blue fill | Object / Participant |
