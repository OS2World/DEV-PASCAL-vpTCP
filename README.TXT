TCP/IP Toolkit for Virtual Pascal
=================================

Version 1.05
Copyright 1996 Antony T Curtis.
All rights reserved.


INSTALLATION
Simply run the INSTALL.CMD file provided.

This version fixes the problem with incompatible
unit file versions and the (unofficial) internal
linker problems in the 1.01 betas.

INTRODUCTION
I've converted some C TCPIP files for use with Virtual Pascal.
Currently, the translation is incomplete, but I hope to have
converted the whole set of C header files into Units and
Includes. When I have the time, I'll be putting updates on to
the Virtual Pascal FTP site and on my own site.



DISCLAIMER
There is absolutely no warranty with these files... If you
screw up, it's your own problem. You may use and spread the
source code supplied as long as all the comments are left
as is. This toolkit may only be distributed as a whole set.



REQUIREMENTS:
        OS/2 TCPIP v2 or
        OS/2 Warp IAK or
        OS/2 Warp Connect/TCPIP v3

        Virtual Pascal v1.0+ for OS/2



INFORMATION
I would appreciate it if my name is left in the source code.
You need not mention me in your software, but it would be
very nice if you would, maybe as a footnote in the Docs ;)

If you have any improvements, or comments, please feel free
to send me an email.

As an aside, I'm also going to make some "programmer friendly"
units to hide the nasties of these librarys...

Included is a Virtual Pascal help file (SOCKETS.VPH).


PROGRAMMING INFO

The Sockets library:
        SOCKETS.INT SOCKETS.VPI SOCKETS.OBJ

    For the available api, please examine the SOCKETS.INT
    file.

Please examine the supplied example files:

        FINGERD.PAS     FINGERD.EXE
                A simple functional Finger Daemon.

        TELNETD.PAS     TELNETD.EXE
                A simple not very functional
                Telnet Daemon.

    Please note: both these programs now use the port
    database to determine what port to use.

    I've tidyied up the way Port numbers... In traditional
    *nix code, functions such as htons() are used to convert
    the endian of the port numbers - this messyness is
    handled within the unit, eliminating onw source of
    possible confusion/bugs.

    The port numbers returned in the GetServiceByName
    function are already processed.

    As illistrated in the TELNETD.PAS, multi-threading
    is possible with this socket library.

    I'am still trying to develop a tidier method, which
    probably won't be very unix-like.

N.B.
        Several structures have been renamed in this
      library to conform to the TP naming convention.

        Original C name   |   Sockets Library name
        ==========================================
Types     sockaddr        |   TSockAddr
          sockaddr_in     |   TSockAddr_in
          hostent         |   THostEnt / PHostEnt
          servent         |   TServEnt / PServEnt
                          |
Procs     socket()        |   Sock_New()
          soclose()       |   Sock_Close()
          bind()          |   Sock_Bind()
          listen()        |   Sock_Listen()
          accept()        |   Sock_Accept()
          send()          |   Sock_Write()
          recv()          |   Sock_Read()
          getservbyname() |   GetServiceByName()
          getservbyport() |   GetServiceByPort()
          getprotbyname() |   GetProtocolByName()
          getprotbynum()  |   GetProtocolByNumber()


        This list is not comprehensive.
        Most of these calls are documented on the
        online help.


HISTORY
  1.04  Simpler installation. Added Select() call.
        Docs not done, due to work on v2.00
  1.03  Added the online help. Tidied up some code.
  1.02  Sorted out the Port numbering system, to make it
        easier.
        Added additional functions from netdb.h
  1.01  Tidier than 1.00
  1.00  First attempt. Basically, a direct port of
        socket.h with a few bits from types.h



THINGS TO DO

        Port the rest of the tcpip librarys.
                ftpapi.h, hameser.h, etc...

        Perhaps make a multithreaded class version.

        Write a proper programmer's manual, maybe
        as an addon to the Virtual Pascal's help system.



CONTACTING THE AUTHOR

        email:  ssu95atc@rdg.ac.uk
        www:    http://nuts.ml.org/

