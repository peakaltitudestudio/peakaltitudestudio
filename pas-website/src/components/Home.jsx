import React from 'react'
import '../styles/Home.css';
// import logo from '../assets/pas-logo.svg';

const videoBg = 'https://pas-bg-videos.s3.us-west-1.amazonaws.com/main1080.mp4'
const instagramURL = 'https://www.instagram.com/peak.altitude.studio/'

const Home = () => {
  return (
    <div className="video-container">
      <div className='overlay'></div>
      <video src={videoBg} autoPlay loop muted/>
      <div className='content'>
        {/* <img src={logo} className="logo"/> */}
        <h2>Welcome to</h2>
        <h1>Peak Altitude Studio</h1>
        <br>
        </br>
        <a style={{color:'#c4a068', 'text-decoration': 'none'}} href={instagramURL} target="_blank" rel="noopener noreferrer">
          Instagram: @peak.altitude.studio
        </a>
        <br></br>
        <p>Phone #: (602)529-2499</p>
      </div>
    </div>
  )
}

export default Home