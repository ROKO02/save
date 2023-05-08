import './App.css';
import ContextAPI from './components/contextApi';
import ContextProvider from './reducer';

function App() {
  return (
    <ContextProvider>
      <ContextAPI/>
    </ContextProvider>
  );
}

export default App;