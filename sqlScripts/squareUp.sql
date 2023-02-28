-- SQUARE UP
-- This script allows user 1 to see how much they are owed by user 2
-- If the amount shown is negative, user 1 owes user 2
-- Remember to replace user 1 and user 2 column names and usernames with the
-- the actual names
SELECT 
(SELECT SUM(User2Share) FROM Transactions WHERE AccountOwner = 'user1_username') - 
(SELECT SUM(User1Share) FROM Transactions WHERE AccountOwner = 'user2_username') +
(SELECT IFNULL((SELECT SUM(User2Share) FROM Transactions WHERE AccountOwner = 'user2_username' AND Recipient = 'user1_username'),0)) - 
(SELECT IFNULL((SELECT SUM(User1Share) FROM Transactions WHERE AccountOwner = 'user1_username' AND Recipient = 'user2_username'),0)) AS User2OwesUser1;