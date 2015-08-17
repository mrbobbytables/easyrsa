## EasyRSA

A small alpine based container wrapping the easy-rsa package with the default vars that will produce the certificates needed for an OpenVPN deployment.

Mout the container with a volume mapped to the `/target` directory and the script will produce the certificates and tarball up the `/keys` directory.

#### Usage
`docker run --rm -it -v $(pwd):/target:rw easyrsa`


#### Output

* `/target/keys.tar.gz` - Compressed tarball of the `keys` directory.
* `/target/server-certs` - Directory containing `CA.crt`, `dh2048.pem`, and the server key/cert.
* `/target/client-certs` - Directory containing `CA.crt`, and any generated client keys/certs.



