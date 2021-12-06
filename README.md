# NZ Covid Pass Verification App

## Overview
Open source javascript app written in Vue2 to scan/decode and verify a NZ COVID Pass.

With this tool you can scan, decode and view the cbor encoded json in your NZ Covid Pass which are not visible in 
the standard application. 

This tool also validates if the pass:

1. is a Base32 encoded NZCP Version 1
2. is encoded as a CBOR
3. has the correct protected headers
4. is issued by New Zealand Ministry of Health by matching the iss in the payload
5. is signed and validated by using the signature of the payload over the CBOR structure using the MOH public key
6. hasn't expired

## Demo
For online demo of this application click <a href="https://d1chdssarsi2bn.cloudfront.net" target="_blank">here</a>

## Technical details

This project uses the following 4 libraries to decode and verify the pass:

1. [Vue QR Code Reader](https://www.npmjs.com/package/vue-qrcode-reader): Detect and decode QR codes
2. [Base32 Decode](https://www.npmjs.com/package/base32-decode): Base32 decoder with support for multiple variants.
3. [CBOR](https://www.npmjs.com/package/cbor): Encode and parse data in the Concise Binary Object Representation (CBOR) data format
4. [COSE](https://www.npmjs.com/package/cose-js): JavaScript implementation of [COSE](https://datatracker.ietf.org/doc/html/rfc8152), [RFC8152](https://datatracker.ietf.org/doc/html/rfc8152)

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

### Node Project Module License List

```
@ellipticoin/cbor@1.0.4 [license(s): MIT]
└── package.json:  MIT

@nuxt/opencollective@0.3.2 [license(s): MIT]
├── package.json:  MIT
└── license files: MIT

@sovpro/delimited-stream@1.1.0 [license(s): MIT]
└── package.json:  MIT

@zxing/library@0.18.6 [license(s): MIT]
├── package.json:  MIT
└── license files: MIT

@zxing/text-encoding@0.9.0 [license(s): (Unlicense OR Apache-2.0), Apache]
├── package.json:  (Unlicense OR Apache-2.0)
└── license files: Apache

ansi-styles@4.3.0 [license(s): MIT]
├── package.json:  MIT
└── license files: MIT

axios@0.24.0 [license(s): MIT]
└── package.json:  MIT

barcode-detector@1.0.0 [license(s): MIT]
├── package.json:  MIT
└── license files: MIT

base32-decode@1.0.0 [license(s): MIT]
└── package.json:  MIT

bigint-buffer@1.1.5 [license(s): Apache, Apache-2.0]
├── package.json:  Apache-2.0
└── license files: Apache

bignumber.js@9.0.1 [license(s): MIT]
├── package.json:  MIT
├── license files: MIT
└── readme files: MIT

bindings@1.5.0 [license(s): MIT]
├── package.json:  MIT
├── license files: MIT
└── readme files: MIT

bootstrap@4.6.1 [license(s): MIT]
├── package.json:  MIT
└── license files: MIT

bootstrap@5.1.3 [license(s): MIT]
├── package.json:  MIT
└── license files: MIT

bootstrap-vue@2.21.2 [license(s): MIT]
├── package.json:  MIT
├── license files: MIT
└── readme files: MIT

callforth@0.3.1 [license(s): MIT]
└── package.json:  MIT

cbor@8.1.0 [license(s): MIT]
├── package.json:  MIT
└── license files: MIT

cbor-bigdecimal@8.1.0 [license(s): MIT]
├── package.json:  MIT
└── license files: MIT

cbor-cli@8.1.0 [license(s): MIT]
├── package.json:  MIT
└── license files: MIT

cborg@1.5.3 [license(s): Apache-2.0]
└── package.json:  Apache-2.0

chalk@4.1.2 [license(s): MIT]
├── package.json:  MIT
└── license files: MIT

color-convert@2.0.1 [license(s): MIT]
└── package.json:  MIT

color-name@1.1.4 [license(s): MIT]
├── package.json:  MIT
└── license files: MIT

commander@8.3.0 [license(s): MIT]
├── package.json:  MIT
└── license files: MIT

consola@2.15.3 [license(s): MIT]
├── package.json:  MIT
└── readme files: MIT

core-js@3.19.1 [license(s): MIT]
└── package.json:  MIT

file-uri-to-path@1.0.0 [license(s): MIT]
├── package.json:  MIT
└── readme files: MIT

follow-redirects@1.14.5 [license(s): MIT]
└── package.json:  MIT

has-flag@4.0.0 [license(s): MIT]
├── package.json:  MIT
├── license files: MIT
└── readme files: MIT

json-text-sequence@1.0.0 [license(s): MIT]
├── package.json:  MIT
└── license files: MIT

jsqr@1.4.0 [license(s): Apache, Apache-2.0]
├── package.json:  Apache-2.0
└── license files: Apache

node-fetch@2.6.6 [license(s): MIT]
├── package.json:  MIT
├── license files: MIT
└── readme files: MIT

nofilter@3.1.0 [license(s): MIT]
├── package.json:  MIT
└── license files: MIT

nz-covidpass@0.1.0 [license(s): Unknown]

popper.js@1.16.1 [license(s): MIT]
└── package.json:  MIT

portal-vue@2.1.7 [license(s): MIT]
├── package.json:  MIT
└── license files: MIT

rtcpeerconnection-shim@1.2.15 [license(s): BSD-3-Clause]
└── package.json:  BSD-3-Clause

sdp@2.12.0 [license(s): MIT]
└── package.json:  MIT

supports-color@7.2.0 [license(s): MIT]
├── package.json:  MIT
└── license files: MIT

tr46@0.0.3 [license(s): MIT]
└── package.json:  MIT

ts-custom-error@3.2.0 [license(s): MIT]
├── package.json:  MIT
└── license files: MIT

uuid-buffer@1.0.3 [license(s): MIT]
├── package.json:  MIT
└── license files: MIT

vue@2.6.14 [license(s): MIT]
├── package.json:  MIT
└── license files: MIT

vue-axios@3.4.0 [license(s): MIT]
├── package.json:  MIT
└── license files: MIT

vue-functional-data-merge@3.1.0 [license(s): MIT]
├── package.json:  MIT
└── license files: MIT

vue-hot-reload-api@2.3.4 [license(s): MIT]
├── package.json:  MIT
└── license files: MIT

vue-loader@16.8.3 [license(s): MIT]
├── package.json:  MIT
└── license files: MIT

vue-qrcode-reader@3.0.6 [license(s): MIT]
├── package.json:  MIT
├── license files: MIT
└── readme files: MIT

webidl-conversions@3.0.1 [license(s): BSD, BSD-2-Clause]
├── package.json:  BSD-2-Clause
└── license files: BSD

webrtc-adapter@7.7.0 [license(s): BSD-3-Clause]
└── package.json:  BSD-3-Clause

whatwg-url@5.0.0 [license(s): MIT]
├── package.json:  MIT
└── license files: MIT

LICENSES: (Unlicense OR Apache-2.0), Apache, Apache-2.0, BSD, BSD-2-Clause, BSD-3-Clause, MIT, Unknown
```
