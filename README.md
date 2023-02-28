# BudgetBunny: Expense Management Toolkit for Couples

<img src="[https://github.com/favicon.ico](https://user-images.githubusercontent.com/19921759/221780348-a369f062-3e2d-4d79-9bc5-e2bbc498c791.png)" height="400">

Budget Bunny is a set of expense management and budgeting scripts that I developed for my own personal budgeting needs. My partner and I use these scripts to ensure that we are living within our means. Although there are many excellent budgeting tools and apps available, such as Mint, Quicken, and Honeydue, they all have limitations. For instance, Mint and Quicken do not provide support for couples budgeting. While Honeydue does offer couples budgeting support, its interface can be difficult to use, and it does not allow for the addition of custom categories. Additionally, each transaction can only be assigned to one category, although different amounts of money can be allocated to various categories from a single transaction.

While Excel offers great flexibility when it comes to budgeting, the manual entry can be quite time-consuming. That's why I decided to develop my own solution to help save time and reach our budget targets. With Budget Bunny, we are able to easily identify transactions that need follow-up, such as missing refunds, and plan our financial future. Overall, Budget Bunny has been a valuable tool that has saved my partner and me countless hours of budgeting work.

I've got big ideas for this repo, but for now it contains the following:

1. `transactionsSync`: Python scripts that extract, clean, and process financial transactions from the Plaid API and upload the processed data to a MySQL database running on AWS RDS (although one could just as easily use a local MySQL database)
2. `sqlScripts`: SQL scripts that enable manual review and analysis of the financial transaction data in the MySQL database
3. `databaseSchema`: The schema used to create the database used by the SQL and Python scripts
4. `server`: A Node.js server that serves as an API for a dashboard
5. `dashboard`: A TypeScript React dashboard with a D3.js "burnup chart" of actual vs estimated expenses

This repo requires access to the [Plaid Developer API](https://plaid.com/docs/api/).
