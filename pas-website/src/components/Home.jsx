import React, { useState } from 'react'
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

  let videoURL = ""
  if (window.innerWidth < 1000) {
    videoURL = baseBucketPath + mobileVideoBg;
  } else {
    videoURL = baseBucketPath + mainVideoBg
  }

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
          <br>
          </br>
        </div>
        <Button className='mute-button' onClick={toggleMute}>
          {isMuted ? <img src={volMute} alt=""/> : <img src={volOn} alt="" />}
        </Button>
      </div>
    </div>
  )
}

export default Home