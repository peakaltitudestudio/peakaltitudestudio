import React, { useState } from 'react'
import Navbar from 'react-bootstrap/Navbar';
import Nav from 'react-bootstrap/Nav';
import Button from 'react-bootstrap/Button'

import '../styles/Home.scss';

import logo from '../assets/pas-logo.svg';

const baseBucketPath = 'https://pas-bg-videos.s3.us-west-1.amazonaws.com/'
const mainVideoBg = 'main1080.mp4'
const mobileVideoBg = 'mobile1080.mp4'
const instagramURL = 'https://www.instagram.com/peak.altitude.studio/'

const Home = () => {
  const [isMuted, setIsMuted] = useState(true);

  let videoURL = ""
  if(window.innerWidth < 1000) {
    videoURL = baseBucketPath + mobileVideoBg;
  } else {
    videoURL = baseBucketPath + mainVideoBg
  }

  const toggleMute = () => {
    setIsMuted(!isMuted);
  };  

  return (
    <div>
      <Navbar bg="secondary" expand="lg">
        <Navbar.Brand href="/">
          <img src={logo} className="logo" alt="Peak Altitude Studio" />
        </Navbar.Brand>
        <Navbar.Toggle aria-controls="basic-navbar-nav" />
        <Navbar.Collapse id="basic-navbar-nav">
          <Nav className="ml-auto">
            <Nav.Link href="/">Home</Nav.Link>
            <Nav.Link href="/about">About</Nav.Link>
            <Nav.Link href="/contact">Contact</Nav.Link>
          </Nav>
          <Button variant="primary" onClick={toggleMute}>
            {isMuted ? 'Unmute' : 'Mute'}
          </Button>
        </Navbar.Collapse>
      </Navbar>
      <div className="video-container">
        <div className='overlay'></div>
        <video autoPlay loop playsInline muted={isMuted}>
            <source src={videoURL} type="video/mp4" />
        </video>
        <div className='content'>
          <h2>Welcome to</h2>
          <h1>Peak Altitude</h1>
          <h1>Studio</h1>
          <br>
          </br>
        </div>
      </div>
    </div>
  )
}

export default Home