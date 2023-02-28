import React, { useEffect, useState } from 'react';
import './App.css';
import BurnupChart from './Burnupchart';

const USERNAME='<>'

function App() {

  const [transactions, setTransactions] = useState([]);
  useEffect(() => {
    async function fetchData() {
      const response = await fetch(`http://localhost:3001/transactions?startDate=2022-01-01&endDate=2022-01-31&category=Food and Drink&username=${USERNAME}`);
      const data = await response.json();
      setTransactions(data);
    }
    fetchData();
  }, []);

  return (
    <div className="App">
       <BurnupChart data={transactions} />
    </div>
  );
}

export default App;
