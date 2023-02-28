-- MANUAL REVIEW AND UPDATES
-- These are a few SQL statements that I use to manually review
-- and update transactions such that each transaction is categorized
-- and split correctly

-- SELECT TransactionId, Name, AuthorizedDatetime, Amount, PrimaryCategory, User1Share, User2Share, WasChecked, Description, ShouldReview, AccountName FROM budgetBunny.Transactions
-- WHERE WasChecked = 0 ORDER BY AuthorizedDatetime DESC;

-- SELECT TransactionId, Name, AuthorizedDatetime, Amount, PrimaryCategory, User1Share, User2Share, WasChecked, Description, ShouldReview, AccountName FROM budgetBunny.Transactions
-- WHERE WasChecked = 0 AND Name LIKE '%Amazon%' ORDER BY AuthorizedDatetime DESC;

-- SELECT TransactionId, Name, AuthorizedDatetime, Amount, PrimaryCategory, User1Share, User2Share, WasChecked, Description, ShouldReview FROM budgetBunny.Transactions
-- WHERE WasChecked = 1 AND (PrimaryCategory = 'Food and Drink' OR PrimaryCategory = 'Supermarkets and Groceries') ORDER BY AuthorizedDatetime DESC;

-- UPDATE Transactions
-- SET WasChecked = 1
-- WHERE WasChecked = 0 AND (PrimaryCategory = 'Food and Drink' OR PrimaryCategory = 'Supermarkets and Groceries');