import React, { useState, useEffect } from 'react'
import PASNavbar from './PASNavbar';
import Button from 'react-bootstrap/Button'

import '../styles/Home.scss';

import volMute from '../assets/volume-mute.svg'
import volOn from '../assets/volume-up-fill.svg'

const baseBucketPath = 'https://pas-bg-videos.s3.us-west-1.amazonaws.com/'
const mainVideoBg = 'main1080.mp4'
const mobileVideoBg = 'mobile1080.mp4'

const Home = () => {
  const [isMuted, setIsMuted] = useState(true);
  const [videoURL, setVideoURL] = useState(baseBucketPath + mainVideoBg);

  useEffect(() => {
    const handleResize = () => {
      setVideoURL(window.innerWidth < 1000 
        ? baseBucketPath + mobileVideoBg 
        : baseBucketPath + mainVideoBg);
    };

    handleResize();
    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

  const toggleMute = () => {
    setIsMuted(!isMuted);
  };

  return (
    <div>
      <PASNavbar/>
      <div className="video-container">
        <div className='overlay'></div>
        <video autoPlay loop playsInline muted={isMuted}>
          <source src={videoURL} type="video/mp4" />
        </video>
        <div className='content'>
          <h3>Welcome to</h3>
          <h1>Peak Altitude</h1>
          <h2>Studio</h2>
          <br />
        </div>
        <Button className='mute-button' onClick={toggleMute}>
          {isMuted ? <img src={volMute} alt="Mute"/> : <img src={volOn} alt="Unmute" />}
        </Button>
      </div>
    </div>
  )
}

export default Home