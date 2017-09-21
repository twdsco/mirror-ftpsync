% RSYNC-SSL-TUNNEL(1)
% Debian mirror team
% ftpsync Manual

# NAME
rsync-ssl-tunnel - Allows rsync to tunnel over TLS

# SYNOPSIS
**rsync-ssl-tunnel**

# DESCRIPTION

**rsync-ssl-tunnel** is part of the ftpsync suite for mirroring Debian and Debian-like
repositories of packages.  As there are way too many mirrors of Debian to populate
them all from the machine that generates the archive ("ftp-master"), mirrors are
organized in a tree-shaped hierarchy.  Thus, every mirror has exactly one upstream
from which it syncs, and each mirror can have any number of downstreams which in
turn sync from it.

# EXAMPLE

Example use with rsync:

  rsync -e rsync-ssl-tunnel

# SEE ALSO
**ftpsync**(1) +
