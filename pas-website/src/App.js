import logo from './pas-logo.svg';
import './App.css';

//colors: primary: #2f4d54
//        secondary: #c4a068

function App() {
  const instagramURL = 'https://junerings.com/products/antique-cut-elongated-cushion-solitaire?_pos=5&_sid=7cf1d4386&_ss=r'
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>Peak Altitude Studio</p>
        <a style={{color:'#c4a068', 'text-decoration': 'none'}} href={instagramURL} target="_blank" rel="noopener noreferrer">
          Juliette Click Here
        </a>
        <p>Phone #: (602)529-2499</p>
        <br></br>
        <br></br>
        <br></br>
        <p>This site is currently under development - Last updated: Sept 26, 2023</p>
      </header>
    </div>
  );
}

export default App;
