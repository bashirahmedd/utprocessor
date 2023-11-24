import { useState } from 'react'
import './App.css'
import TestQuestion from './components/TestQuestion';

function App() {
  const [count, setCount] = useState(0);
  const examData = [
    {
      "q": "What is the name of your country?",
      "options": ["Canada", "Pakistan", "UAE"]
    },
    {
      "q": "What is the name of your religion?",
      "options": ["Islam", "Christianity", "Budhism"]
    },
    {
      "q": "What is the type of your favourite food?",
      "options": ["Meat", "Vegetable", "Fruit", "Spicy Snack"]
    }
  ]
  const MAXLIMIT = examData.length -1 ;
  console.log(MAXLIMIT)
  return (
    <>
      {/* { ( count < 0 && count > MAXLIMIT ) ? <div></div> :<TestQuestion question={examData[count]} ></TestQuestion> } */}
      <TestQuestion question={examData[count]} ></TestQuestion>
      <div className="card">
        <button onClick={(e) => setCount((count) => count - 1)}>
          Previous : {count}
        </button>
        <button onClick={(e) => setCount((count) => count + 1)}>
          Next : {count}
        </button>
      </div>
    </>
  )
}

export default App
