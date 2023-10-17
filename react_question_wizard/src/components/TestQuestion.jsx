import React from 'react'

const TestQuestion = ({ question }) => {
    //debugger;
    console.log(question);
    if (typeof (question) !== 'undefined' && question != null) {
        console.log('Not Undefined and Not Null');        
    } else {
        console.log('Undefined or Null');
        return (<div>Question not found, going beyond limit.</div>);
    }

    return (
        <div>
            <p>{question["q"]}</p>
            {question["options"].map((val) => {
                return (
                    <p>{val}</p>
                )
            })}
        </div>
    )
}

export default TestQuestion