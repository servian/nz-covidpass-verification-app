<template>
  <div id="app">
    <b-container class="mt-4">
      <b-row align-v="start">
        <b-col order="2" order-sm="2" order-md="1" cols="12" sm="12" md="7">
          <hr class="mb-4 pt-0 mt-0">
          <b-jumbotron header="NZ Covid Pass Verification" lead="Proof of concept for verification of My Vaccine Pass">
          </b-jumbotron>
          <hr class="my-4">
          <h4 class="mb-3">The New Zealand COVID Pass is a digitally signed payload optimised for rendering via a 2D
            barcode for
            easy machine verifiability.</h4>
          <p class="decode-result">
            <b-alert :variant="alertBoxVariant" show>{{ prompt }}</b-alert>
          </p>
          <div v-if="onscreenLogs">
            <b-form-textarea v-model="onscreenLogs" max-rows="99" disabled></b-form-textarea>
          </div>
        </b-col>
        <b-col order="1" order-sm="1" order-md="2" cols="12" sm="12" md="5">
          <qrcode-stream class="steam-box" :camera="camera" @decode="onDecode" @init="onInit"
                         :track="this.paintOutline">
            <div v-if="validationSuccess" class="validation-success">
              Your Covid Pass is Valid!
            </div>

            <div v-if="validationFailure" class="validation-failure">
              Your Covid Pass is not valid!
            </div>

            <div v-if="validationPending" class="validation-pending">
              Please wait while we validate your Covid Pass!
            </div>
          </qrcode-stream>
        </b-col>
      </b-row>
    </b-container>
  </div>
</template>

<script>
import base32Decode from 'base32-decode';
import cbor from 'cbor';
import cose from 'cose-js';

export default {
  data() {
    return {
      isValid: undefined,
      camera: 'auto',
      prompt: 'Please center the Covid Pass QR code you want to scan on the screen.',
      onscreenLogs: '',
      alertBoxVariant: 'info'
    }
  },

  computed: {
    validationPending() {
      return this.isValid === undefined
          && this.camera === 'off';
    },
    validationSuccess() {
      return this.isValid === true;
    },
    validationFailure() {
      return this.isValid === false;
    }
  },
  methods: {
    async decodeAndVerifyQrCode(code) {
      this.onscreenLogs += 'QR code string:' + '\n';
      this.onscreenLogs += code + '\n' + '\n';
      let base32encoded = code.split("/");

      if (base32encoded[0] !== "NZCP:") {
        throw 'Not a Valid NZCP pass';
      }

      if (base32encoded[1] !== "1") {
        throw 'Version mismatch';
      }

      base32encoded = base32encoded[base32encoded.length - 1];
      const decodedBuffer = base32Decode(base32encoded, 'RFC4648');
      const cborArray = await cbor.decodeAll(decodedBuffer);

      const headers = await this.decodeHeaders(cborArray[0].value[0]);
      this.onscreenLogs += 'Extracted protected header:' + '\n';
      this.onscreenLogs += JSON.stringify(headers, undefined, 2) + '\n' + '\n';

      const payload = await this.decodePayload(cborArray[0].value[2]);
      this.onscreenLogs += 'Extracted protected payload:' + '\n';
      this.onscreenLogs += JSON.stringify(payload, undefined, 2) + '\n' + '\n';

      const jwk = await this.resolveIdentityWithIssuer(headers, payload);
      this.onscreenLogs += 'Issuer public key:' + '\n';
      this.onscreenLogs += JSON.stringify(jwk, undefined, 2) + '\n' + '\n';

      this.onscreenLogs += 'COSE Verification using the resolved public key and CWT process:' + '\n';
      await this.verifySignature(jwk, decodedBuffer);
      this.onscreenLogs += 'Result: Signature matches, no tempering detected in payload.' + '\n' + '\n';

      return payload;
    },
    async verifySignature(jwk, base32DecodedBuffer) {
      const verifier = {
        'key': {
          'x': Buffer.from(Buffer.from(jwk.x, 'base64').toString('hex'), 'hex'),
          'y': Buffer.from(Buffer.from(jwk.y, 'base64').toString('hex'), 'hex')
        }
      };

      return await cose.sign.verify(base32DecodedBuffer, verifier);
    },
    async resolveIdentityWithIssuer(headers, payload) {
      const kid = headers.kid;
      const iss = payload.iss;
      const absoluteKeyReference = `${iss}#${kid}`;

      if (iss !== "did:web:nzcp.identity.health.nz") {
        throw 'Not a New Zealand Ministry of Health trusted issuer';
      }

      // await axios.get('https://nzcp.identity.health.nz/.well-known/did.json')
      //     .catch(() => {
      //       throw 'Unable to fetch authority DID';
      //     });
      // Hard coded because getting CORS error on GET: https://nzcp.identity.health.nz/.well-known/did.json
      // This will need to be implemented as a proxy
      // TODO: Store authority in LocalStorage for 15 days
      const authority = {
        "data": {
          "id": "did:web:nzcp.identity.health.nz",
          "@context": [
            "https://w3.org/ns/did/v1",
            "https://w3id.org/security/suites/jws-2020/v1"
          ],
          "verificationMethod": [
            {
              "id": "did:web:nzcp.identity.health.nz#z12Kf7UQ",
              "controller": "did:web:nzcp.identity.health.nz",
              "type": "JsonWebKey2020",
              "publicKeyJwk": {
                "kty": "EC",
                "crv": "P-256",
                "x": "DQCKJusqMsT0u7CjpmhjVGkHln3A3fS-ayeH4Nu52tc",
                "y": "lxgWzsLtVI8fqZmTPPo9nZ-kzGs7w7XO8-rUU68OxmI"
              }
            }
          ],
          "assertionMethod": [
            "did:web:nzcp.identity.health.nz#z12Kf7UQ"
          ]
        }
      };

      const authorityData = authority.data;
      if (!authorityData['assertionMethod'].includes(absoluteKeyReference)) {
        throw 'Key mismatch';
      }

      if (!(authorityData['verificationMethod'][0]['type'] === 'JsonWebKey2020')) {
        throw 'Verification method failure';
      }

      return authorityData['verificationMethod'][0]['publicKeyJwk'];
    },
    async decodeHeaders(buffer) {
      const decodedPayload = await cbor.decodeAll(buffer);
      const decodedHeaderObject = Object.fromEntries(decodedPayload[0]);
      const kidBuffer = decodedHeaderObject[4];
      const algVal = decodedHeaderObject[1];
      const kidVal = new Buffer(kidBuffer).toString();

      // Hard coded because: https://nzcp.covid19.health.nz/#cwt-headers
      if (algVal === -7 && kidVal !== null) {
        return {
          'kid': kidVal,
          'alg': 'ES256'
        }
      } else {
        throw 'unable to extract headers';
      }
    },
    async decodePayload(buffer) {
      const decodedPayload = await cbor.decodeAll(buffer);
      const decodedPayloadObject = Object.fromEntries(decodedPayload[0]);
      const hexUiid = 'urn:uuid:' + this.formatHex2Uiid(this.buffer2hex(decodedPayloadObject[7]));
      const expiryDate = new Date(decodedPayloadObject[4] * 1000);
      if (new Date().getTime() - expiryDate.getTime() > 0) {
        throw 'pass expired';
      }
      return {
        "iss": decodedPayloadObject[1],
        "exp": decodedPayloadObject[4],
        "nbf": decodedPayloadObject[5],
        "jti": hexUiid,
        "vc": decodedPayloadObject['vc']
      }
    },
    formatHex2Uiid(hex) {
      let lengths = [8, 4, 4, 4, 12];
      let parts = [];
      let range = 0;
      for (let i = 0; i < lengths.length; i++) {
        parts.push(hex.slice(range, range + lengths[i]));
        range += lengths[i];
      }
      return parts.join('-');
    },
    buffer2hex(buffer) {
      return [...new Uint8Array(buffer)]
          .map(x => x.toString(16).padStart(2, '0'))
          .join('');
    },
    onInit(promise) {
      promise
          .catch(console.error)
          .then(this.resetValidationState)
    },
    resetValidationState() {
      this.isValid = undefined
    },
    async onDecode(qrCode) {
      this.turnCameraOff()
      try {
        this.onscreenLogs = '';
        this.prompt = 'Please wait...';
        this.alertBoxVariant = "warning";
        let QRCodeData = await this.decodeAndVerifyQrCode(qrCode);
        this.isValid = true;
        let expDate = new Date(QRCodeData.exp * 1000);
        expDate = expDate.getDate() +
            "/" + (expDate.getMonth() + 1) +
            "/" + expDate.getFullYear();
        this.prompt = `Kia Ora! ${QRCodeData.vc.credentialSubject.givenName} ${QRCodeData.vc.credentialSubject.familyName},
        Your pass is valid till ${expDate}`;
        this.alertBoxVariant = "success";
      } catch (e) {
        this.isValid = false;
        this.prompt = 'We were unable to verify your covid pass!'
        this.onscreenLogs += e;
        this.alertBoxVariant = "danger";
        console.log(e);
      } finally {
        await this.timeout(5000);
        this.turnCameraOn()
      }
    },
    turnCameraOn() {
      this.camera = 'auto';
    },
    turnCameraOff() {
      this.camera = 'off';
    },
    timeout(ms) {
      return new Promise(resolve => {
        window.setTimeout(resolve, ms);
      })
    },
    paintOutline(detectedCodes, ctx) {
      for (const detectedCode of detectedCodes) {
        const [firstPoint, ...otherPoints] = detectedCode.cornerPoints

        ctx.strokeStyle = "red";

        ctx.beginPath();
        ctx.moveTo(firstPoint.x, firstPoint.y);
        for (const {x, y} of otherPoints) {
          ctx.lineTo(x, y);
        }
        ctx.lineTo(firstPoint.x, firstPoint.y);
        ctx.closePath();
        ctx.stroke();
      }
    },
  }
}
</script>

<style scoped>
.validation-success,
.validation-failure,
.validation-pending {
  position: absolute;
  width: 100%;
  height: 100%;

  background-color: rgba(255, 255, 255, .8);
  text-align: center;
  font-weight: bold;
  font-size: 1.4rem;
  padding: 10px;

  display: flex;
  flex-flow: column nowrap;
  justify-content: center;
}

.validation-success {
  color: green;
}

.validation-failure {
  color: red;
}
</style>