------------------------------------------------------------------------------
--                            IPSTACK COMPONENTS                            --
--             Copyright (C) 2010, Free Software Foundation, Inc.           --
------------------------------------------------------------------------------

--  AIP configuration parameters

--# inherit AIP;

package AIP.Config is
   TCP_DEFAULT_LISTEN_BACKLOG : constant := 5;

   UDP_TTL : constant := 255;
end AIP.Config;
