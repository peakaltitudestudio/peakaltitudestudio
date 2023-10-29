import React from 'react'
import PASNavbar from './PASNavbar';

const instagramURL = 'https://www.instagram.com/peak.altitude.studio/'

const Home = () => {
  return (
    <div>
      <PASNavbar></PASNavbar>
      <div className="video-container">
        <div className='overlay'></div>
        <div className='content'>
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