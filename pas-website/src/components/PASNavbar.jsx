import React from 'react'
import Navbar from 'react-bootstrap/Navbar';
import Nav from 'react-bootstrap/Nav';
// import Button from 'react-bootstrap/Button'

import logo from '../assets/pas-logo.svg';

const PASNavbar = () => {
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
                    {/* <Button variant="primary" onClick={toggleMute}>
                        {isMuted ? 'Unmute' : 'Mute'}
                    </Button> */}
                </Navbar.Collapse>
            </Navbar></div>
    )
}

export default PASNavbar