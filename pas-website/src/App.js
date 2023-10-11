import './App.css';

//colors: primary: #2f4d54
//secondary: #c4a068

function App() {
  const ringURL = 'https://junerings.com/products/antique-cut-elongated-cushion-solitaire?_pos=5&_sid=10e00d20b&_ss=r'
  return (
    <div className="App">
      <header className="App-header">
        <a style={{color:'pink', 'text-decoration': 'none'}} href={ringURL} target="_blank" rel="noopener noreferrer">
          Juliette
        </a>
        <br></br>
        <br></br>
        <br></br>
      </header>
    </div>
  );
}

export default App;
