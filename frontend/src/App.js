import React, { useState, useEffect } from 'react';
import './App.css';

function App() {
    const [message, setMessage] = useState('Загрузка...');
    const [products, setProducts] = useState([]);

    useEffect(() => {
        // Получаем данные с бэкенда
        fetch('http://localhost:8000/')
            .then(res => res.json())
            .then(data => setMessage(data.message))
            .catch(err => setMessage('Ошибка подключения к серверу'));

        fetch('http://localhost:8000/products')
            .then(res => res.json())
            .then(data => setProducts(data.products))
            .catch(err => console.log(err));
    }, []);

    return (
        <div className="App">
            <h1>Завод по производству вафельных стаканчиков</h1>
            <p>{message}</p>
            
            <h2>Наша продукция:</h2>
            <ul>
                {products.map((product, index) => (
                    <li key={index}>{product}</li>
                ))}
            </ul>
        </div>
    );
}

export default App;