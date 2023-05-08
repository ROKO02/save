import React, { useCallback, useState } from "react";
import TodoTitle from "../components/todoTitle";
import TodoForm from "../components/todoForm";
import TodoList from "../components/todoList";



const Todos = () => {
    const [state, setState] = useState([
        {
            id: 1,
            Todo: "리액트 공부하기"
        },
        {
            id: 2,
            Todo: "리액트 또 공부하기"
        }
    ])

    const onAddhandler = useCallback((id, Todo)=>{
        setState([...state, {id: id, Todo: Todo}])
    }, [])

    return (
        <>
            <TodoTitle count={state.length}/>
            <TodoForm
                onAddhandler = {onAddhandler} id={state.length > 0 && state[state.length-1].id}
            />
            {state.map((v) => (
                <TodoList key={v.id} state={v}/>
            ))}
        </>
    );
}
export default Todos;