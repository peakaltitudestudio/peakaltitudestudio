import React from 'react'
import PASNavbar from './PASNavbar'

import '../styles/About.scss';

const About = () => {
  return (
    <div>
      <PASNavbar />
      <div class="main">
        <div className='text-container'>
          <h1>Real Estate Videography</h1>
          <h5>Located in Scottsdale, Arizona</h5>
        </div>
      </div>
    </div>
  )
}

export default About