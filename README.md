# Docker MLflow: A docker script which sets up an all-in-one MLflow server
A docker-compose setup that sets up a backend MLflow server (sqlite) and artifact 
store (SFTP) on the directories you specify.
An nginx proxy is provided which adds HTTP Basic Auth with SSL and the sFTP 
likewise requires authentication, which makes it safe(ish) to expose them to the clearnet. 

A `.env.example` file is provided which allows you to quickly set up a configuration
to your liking.
The configuration uses volume binds, so the backend and artifact stores use
local system directories (by default `./artifacts` and `./backend`).
As a result, this set up is completely portable.

Moving servers? Just transfer this folder to the new one.

## Installation
Start by copying `.env.example` to `.env` and modifying it to taste.
It should work as is.
```bash
cp .env.example .env
```

### Docker UID
If you change the UID/GID of docker through `.env` (so you can modify files 
without root), you'll have to create the bind directories yourself, because 
docker will create them using the root user.
```bash
mkdir -p artifacts backend cert
```

### Domains
If you'd rather use a domain name instead of an IP to make it easier to remember
when setting up machines and you don't have one, check out [Duck DNS](https://duckdns.org)
and [Freenom](https://www.freenom.com/). You can get `.tk` domains from freedom and
`.duck-dns.org` from Duck DNS (which can auto-update), no credit card required.
Place your domain in `MLFLOW_ARTIFACT_URI` and use it when specifying the server in clients.

[Cloudflare](http://cloudflare.com/) is a good free DNS service if using Freenom.

### Firewall
We will be exposing ports on the host machine.
Before continuing, install `ufw` if not already installed and enable it.
``` bash
sudo apt update && sudo apt install ufw
sudo ufw allow ssh
sudo ufw enable
sudo ufw status
```

### Running
Do a trial run by running the following:
```bash
docker-compose up
```
You can exit with `ctrl+C`, test everything works as expected.

If you make any changes, type the following to scrap the containers before restarting:
```bash
docker-compose down
```

Finally, use the following to launch in the background (detached mode) and monitor
using the log command
```bash
docker-compose up -d
docker-compose logs -f
```

You can always stop the containers without removing them with the following:
```bash
docker-compose stop
```

If you wish to test a service on its own you can specify it at launch.
Then, only it and its dependencies will be launched.
```bash
docker-compose up flow
```

### Firewall Continued
You can now allow traffic to the secured backend port and the sftp port.

```bash
sudo ufw allow 23
sudo ufw allow 80
# or
sudo ufw allow 443
```
If you are launching a VM behind a modern cloud, you will also have to modify
the security group and forward the ports there as well
(the ssh port is forwarded by default).

### Using SSL
NGINX forwards the backend using HTTP Basic Auth to ports 80 (HTTP) and
443 (HTTPS).
Use whichever you prefer.
The keys for the SSL connection are placed on the cert folder and you can replace
them with your own.

The cert will support the domain names and IPs you specified in `.env`.
Just point `MLFLOW_TRACKING_SERVER_CERT_PATH` to `nginx.crt` and the `https` connection
will be secured.
However, IP wildcards are not supported, so to use an IP you will either need to 
use your own certificate or modify `./nginx/gen_key.sh`.

> By using the HTTP protocol, so it's trivial for a MITM to steal your credentials

> Consider using HTTPS with `MLFLOW_TRACKING_INSECURE_TLS` or `MLFLOW_TRACKING_SERVER_CERT_PATH`.

### Client Set-up
First, you need to add the host keys of the artifact server to the `known_hosts`
file (change port and domain to your own):
```bash
ssh-keyscan -H -p 23 yourdomain.com >> ~/.ssh/known_hosts
```

Then, launch your python code while specifying the tracking server using environment
variables.
Below is an example of a bash file you could use to set the environment variables
for your client using SSL.
```bash
export MLFLOW_TRACKING_URI=https://127.0.0.1
export MLFLOW_TRACKING_USERNAME=mlflow
export MLFLOW_TRACKING_PASSWORD=12345
export MLFLOW_TRACKING_SERVER_CERT_PATH=./cert/nginx.crt
# export MLFLOW_TRACKING_INSECURE_TLS=true

python flow.py
```

## Credits
This repository extends Andy Ganse's 
[aganse/docker_mlflow_db](https://github.com/aganse/docker_mlflow_db)
repository by simplifying it and making it ready to use.
It also implements some best practices from web development for using docker.

HTTP Basic Auth is now provided by default by nginx and the username and password
are set using the `.env` file.
NGINX also forwards an https port and a self signed certificate is generated for you.
By placing that certificate in the client and setting the proper environment variable
you can use mlflow securely with TLS.

I do not see the reason for using PostgreSQL for a server used by one researcher.
So sqlite is used for the backend.
As I use MLflow I might change my mind though.

Old credits:
Originally based on [Guillaume Androz's 10-Jan-2020 Toward-Data-Science post,
"Deploy MLflow with docker compose"]
(https://towardsdatascience.com/deploy-mlflow-with-docker-compose-8059f16b6039),
with some changes to:
* replace AWS usage with local mapping for artifact store
* replace mysql with postgresql and other options.
* optionally apply htpasswd access control to mlflow website via nginx frontend