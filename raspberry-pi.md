# Raspberry PI install notes

hostname: echo
local IP: 237

# Projects
## Getting Internet SSH/HTTP(S) traffic into server

Local network traffic works out of box (or after installing nginx).

Extra-network traffic needs a bit more help. Do the following:
* In router, set server to have a permanently-allocated IP.
* In router, port-forward 80, 443 and 22 to that IP.
* On server, add appropriate entries to `.ssh/authorized_keys`. Note that sshd is ssh on modern Ubuntus.
* Follow this. Note especially the part about `ufw`. https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-20-04#step-1-creating-the-key-pair

