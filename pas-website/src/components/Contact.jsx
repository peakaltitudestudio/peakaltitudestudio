import React from 'react'
import PASNavbar from './PASNavbar';

import '../styles/Contact.scss'

import logo from '../assets/pas-logo.svg'
import igLogo from '../assets/instagram.svg'
import phoneSVG from '../assets/phone.svg'

const instagramURL = 'https://www.instagram.com/peak.altitude.studio/'

const Home = () => {
    return (
        <div>
            <PASNavbar />
            <div className='contact-main'>
                <a className="ig" href={instagramURL} target="_blank" rel="noopener noreferrer">
                    <img className="ig-logo" src={igLogo} alt=""></img>
                    @peak.altitude.studio
                </a>
                <br />
                <div className='contact-phone'>
                    <img className='phone-icon' src={phoneSVG} alt=""></img>
                    <p>(602)529-2499</p>
                </div>
                <div className="contact-pas-logo-container">
                    <img className='contact-pas-logo' src={logo} alt=""></img>
                </div>
            </div>
        </div>
    )
}

export default Home