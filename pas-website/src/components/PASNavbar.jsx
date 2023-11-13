import React from 'react'
import Navbar from 'react-bootstrap/Navbar';
import Nav from 'react-bootstrap/Nav';

import "../styles/PASNavbar.scss"
import logo from '../assets/pas-logo.svg';

const PASNavbar = () => {
    return (
        <div>
            <Navbar bg='dark' variant='dark' expand="lg">
                <Navbar.Brand href="/" className='ms-auto'>
                    <img src={logo} className="brand-logo" alt="Peak Altitude Studio" />
                    <h5>Peak Altitude Studio</h5>
                </Navbar.Brand>
                <Navbar.Toggle aria-controls="basic-navbar-nav" className='ms-auto'/>
                <Navbar.Collapse id="basic-navbar-nav">
                    <Nav className="ms-auto">
                        <Nav.Link href="/">Home</Nav.Link>
                        <Nav.Link href="/portfolio">Portfolio</Nav.Link>
                        <Nav.Link href="/about">About</Nav.Link>
                        <Nav.Link href="/contact">Contact</Nav.Link>
                    </Nav>
                </Navbar.Collapse>
            </Navbar>
        </div>
    )
}

export default PASNavbar