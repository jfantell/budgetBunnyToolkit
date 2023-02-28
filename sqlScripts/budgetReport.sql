-- BUDGET REPORT
-- See how your actual expenses compare with your
-- budgeted expenses
SELECT PrimaryCategory, SUM(User1Share) As Expenses FROM budgetBunny.Transactions 
WHERE Year(AuthorizedDatetime) = 2023 AND Month(AuthorizedDatetime) = 1
GROUP BY PrimaryCategory;