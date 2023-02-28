require('dotenv').config('../.env');

const express = require('express');
const cors = require('cors')
const mysql = require('mysql');
const app = express();

app.use(cors())

const host = process.env.DB_HOST;
const user = process.env.DB_USER;
const password = process.env.DB_PASSWORD;
const database = process.env.DB_NAME;

function getDatesBetween(startDateStr, endDateStr) {
    const dates = [];
    let currentDate = new Date(startDateStr);
    let endDate = new Date(endDateStr);
    while (currentDate <= endDate) {
        dates.push(new Date(currentDate).toISOString().substring(0, 10));
        currentDate.setDate(currentDate.getDate() + 1);
    }
    return dates;
}

// Create a MySQL connection pool
const pool = mysql.createPool({
    connectionLimit: 10,
    host: host,
    user: user,
    password: password,
    database: database,
});

// Define the endpoint that fetches the data
app.get('/transactions', (req, res) => {
    const { category, startDate, endDate, username } = req.query;

    // Construct the SQL query
    const sql = `
      SELECT DATE(AuthorizedDateTime) as date, SUM(amount) as totalAmount
      FROM Transactions
      WHERE PrimaryCategory = ? AND DATE(AuthorizedDateTime) >= ? AND DATE(AuthorizedDateTime) <= ? AND AccountOwner = ?
      GROUP BY DATE(AuthorizedDateTime)
    `;

    // Execute the SQL query using the connection pool
    pool.query(sql, [category, startDate, endDate, username], (error, results) => {
        if (error) {
            console.error(error);
            res.status(500).json({ error: 'Internal server error' });
            return;
        }

        const transactionData = results.reduce((acc, { date, totalAmount }) => {
            const dateStr = date.toISOString().substring(0, 10);

            if (!acc[dateStr]) {
                acc[dateStr] = 0;
            }

            acc[dateStr] += totalAmount;

            return acc;
        }, {});

        const dates = getDatesBetween(startDate, endDate);
        console.log(dates);

        const data = [];
        let cumulative_amount = 0;
        for (date of dates)
        {
            if (transactionData[date])
            {
                cumulative_amount += transactionData[date]
            }
            data.push({date: date, cumulative_amount: cumulative_amount})
        }

        // Send the data to the client
        res.json(data);
    });
});

// Start the server
app.listen(3001, () => {
    console.log('Server started on port 3001');
});