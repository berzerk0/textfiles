
 
 
# If needed, tunnel into the Nessus host with port forwarding.

On the local machine:

`ssh -D PORT-TO-FORWARD -i PATH-TO-KEY USERNAME@HOST`


# Configure iptables on the Nessus host such that the nessus interface will not be accessible from anywhere but loopback

On the nessus host:

```
sudo iptables -A INPUT -i lo -p tcp --dport 8834 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 8834 -j DROP
```


# Start Nessus Docker image

On the nessus host:

```
docker run --network host --name "benb-nessus-docker" -d -p 127.0.0.1:8834:8834 tenableofficial/nessus
```


# Use Nessus

If nessus host is not the local machine, SOCKS5 proxy a browser on the local machine to it, then visit the nessus page. If Nessus will run on the local machine, proxying the browser is not required:


Visit this page in the browser
`https://localhost:8834`


# Stop Nessus Docker image

(Run on the nessus host)

Stop the docker image

`docker stop benb-nessus-docker`


Remove Docker Container

`docker rm benb-nessus-docker`


delete docker image

`docker image rm tenableofficial/nessus`


super scrub (will remove other docker containers)

`docker system prune -a`
