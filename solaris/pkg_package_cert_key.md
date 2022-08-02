# How to Install a Certificate and Key for the Oracle Solaris Support Repository

1. Get certificate and key files

- Open the Oracle Certificate Request site.
- In your browser, navigate to https://pkg-register.oracle.com/
- Sign in to the site
- Select the Request Certificates link
- Sign in using your My Oracle Account support credentials
- Find the Oracle Solaris 11 Support repository, and select the Request Access button
- Read the license and select the Accept button
- Open the Certificate Information page
- On the Product Details page, select the "certificate page" link or navigate to https://pkg-register.oracle.com/register/certificate/
- Select the Download Certificate button, and save the certificate file on your system
- Select the Download Key button, and save the key file on your system

2. Configure the solaris publisher using the new certificate and key files.

- The arguments to the -c and -k options are the certificate and key files that you downloaded in the previous step, as shown in the following example:

```
pkg set-publisher -g https://pkg.oracle.com/solaris/support/ \
> -c ~/Downloads/pkg.oracle.com.certificate.pem \
> -k ~/Downloads/pkg.oracle.com.key.pem  solaris
```
