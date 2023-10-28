import React, { useEffect, useState } from 'react'
import Navbar from 'react-bootstrap/Navbar';
import Nav from 'react-bootstrap/Nav';

import '../styles/Home.scss';

import logo from '../assets/pas-logo.svg';

const baseBucketPath = 'https://pas-bg-videos.s3.us-west-1.amazonaws.com/'
const mainVideoBg = 'main1080.mp4'
const mobileVideoBg = 'mobile1080.mp4'
const instagramURL = 'https://www.instagram.com/peak.altitude.studio/'

const Home = () => {
  const [isMobile, setIsMobile] = useState(false);

  useEffect(() => {
    // Use some criteria to detect if it's a mobile device
    const isMobileDevice = window.innerWidth < 768; // You can adjust this threshold

    setIsMobile(isMobileDevice);
  }, []);

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
        </Navbar.Collapse>
      </Navbar>
      <div className="video-container">
        <div className='overlay'></div>
        <video autoPlay loop muted>
          {isMobile ? (
            <source src={baseBucketPath + mobileVideoBg} type="video/mp4" />
          ) : (
            <source src={baseBucketPath + mainVideoBg} type="video/mp4" />
          )}
          Your browser does not support the video tag.
        </video>
        <div className='content'>
          <h2>Welcome to</h2>
          <h1>Peak Altitude</h1>
          <h1>Studio</h1>
          <br>
          </br>
          <a style={{ color: '#c4a068', 'text-decoration': 'none' }} href={instagramURL} target="_blank" rel="noopener noreferrer">
            Instagram: @peak.altitude.studio
          </a>
          <br></br>
          <p>Phone #: (602)529-2499</p>
        </div>
      </div>
    </div>
  )
}

export default Home