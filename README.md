# NZ Covid Pass Verification App

## Overview
Open source javascript app written in Vue2 to scan/decode and verify a NZ COVID Pass.

With this tool you can scan, decode and view the cbor encoded json in your NZ Covid Pass which are not visible in 
the standard application. 

This tool also validates if the pass:

1. is a Base32 encoded NZCP Version 1
2. is encoded as a CBOR
3. has the correct protected headers
4. is issued by New Zealand Ministry of Health by matching the iss
5. is signed and validate the signature of the payload over the CBOR structure using the MOH public key
6. hasn't expired

## Demo
For online demo of this application click [here](https://d1chdssarsi2bn.cloudfront.net)

## Technical details

This project uses the following 4 libraries to decode and verify the pass:

1. [Vue QR Code Reader](https://www.npmjs.com/package/vue-qrcode-reader): Decode QR to string
2. [Base32 Decode](https://www.npmjs.com/package/base32-decode): Decode to CBOR
3. [CBOR](https://www.npmjs.com/package/cbor): Decode CBOR
4. [COSE](https://www.npmjs.com/package/cose-js): Verify CBOR

## Requirements
* `docker` (For serving the app for local development)
* `docker-compose` (v1.22 minimum, for serving the app for local development)
* `make` (For helper commands)

## Quick Start
1. `make start`

### Make Commands
* `make build` - Run a production build and output the generated files to `dist`
* `make exec` - Start an interactive command prompt in the local development container
* `make lint` - Lint the project with ESLint
* `make logs` - View and follow logs for the local development container
* `make restart` - Restart the local development container (Useful if Webpack file watchers break)
* `make start` - Start the local development container
* `make stop` - Stop and remove the local development container

## Contributing
Open an issue or a pull request to suggest changes or additions.

### Commit Messages
All commit messages should try to match the regex
`/^NZVA-[\d]{1,4} - [A-Z].*[\w)]$/`. In short (see
[here](https://chris.beams.io/posts/git-commit/) for details):
* Titles should try to not exceed 50 characters and should never exceed 72 characters
    * Use the message body for further info on how/why you made your change
* Titles should be capitalised
* Titles should not end in a period
* Titles should be in the imperative mood (`Add feature A` not `Added feature A`)
* Separate the body from the title with an empty line
* The body should wrap at 72 characters

Bad:
* `Updated readme to include guidelines on good commit message format.`
* `[NZVA-123] updated readme to include guidelines on good commit message format`
* `NZVA-123 - Added commit message guidelines to README`

Good:
* `NZVA-123 - Add commit message guidelines to README`

