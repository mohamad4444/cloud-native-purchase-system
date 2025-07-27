import Keycloak from 'https://cdn.jsdelivr.net/npm/keycloak-js@26.2.0/+esm';
console.log("App loaded!");
document.addEventListener('DOMContentLoaded', function () {
  console.log("DOM fully loaded and parsed");
  const keycloak = new Keycloak({
    url: 'http://localhost:8180/',
    realm: 'purchase-service-realm',
    clientId: 'web-frontend-client'
  });
  console.log("ketcloak Created");
  keycloak.init({
    pkceMethod: 'S256',
    checkLoginIframe: false,
	  redirectUri: window.location.origin,
	scope: 'openid profile email offline_access'
  }).then(authenticated => {
    if (authenticated) {
      onAuthenticated();
    } else {
      document.getElementById('loginBtn').style.display = 'inline';
    }

    //  Bind login after init
    document.getElementById('loginBtn').addEventListener('click', () => {
      keycloak.login({ redirectUri: window.location.href });
    });

    document.getElementById('logoutBtn').addEventListener('click', () => {
      keycloak.logout({ redirectUri: window.location.href });
    });
  }).catch(err => {
    console.error('Keycloak init error:', err);
  });
document.getElementById('callUserHello').addEventListener('click', async () => {
  callHelloEndpoint('/hello/user');
});

document.getElementById('callAdminHello').addEventListener('click', async () => {
  callHelloEndpoint('/hello/admin');
});

async function callHelloEndpoint(url) {
  try {
    const response = await fetch(url, {
      headers: {
        'Authorization': 'Bearer ' + keycloak.token
      }
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    const text = await response.text();
    document.getElementById('helloResponse').textContent = `Response: ${text}`;
  } catch (err) {
    document.getElementById('helloResponse').textContent = `Error: ${err}`;
  }
}





  function onAuthenticated() {
    document.getElementById('loginBtn').style.display = 'none';
    document.getElementById('logoutBtn').style.display = 'inline';
    document.getElementById('purchaseSection').style.display = 'block';

    document.getElementById('user-info').textContent = `Hello ${keycloak.tokenParsed?.preferred_username}`;
    window.accessToken = keycloak.token;

    // Refresh token loop
    setInterval(() => {
      keycloak.updateToken(30).then(refreshed => {
        if (refreshed) {
          console.log('Token refreshed');
          window.accessToken = keycloak.token;
        }
      }).catch(() => {
        console.error('Token refresh failed');
        keycloak.logout({ redirectUri: window.location.href });
      });
    }, 60000);

    document.getElementById('purchaseForm').addEventListener('submit', async (e) => {
      e.preventDefault();
      const product = document.getElementById('product').value;
      const quantity = document.getElementById('quantity').value;

      try {
        const response = await fetch('/api/purchase', {
          method: 'POST',
          headers: {
            'Authorization': 'Bearer ' + keycloak.token,
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({ productName: product, quantity: Number(quantity) })
        });

        const result = await response.text();
        document.getElementById('result').textContent = `Server response: ${result}`;
      } catch (err) {
        document.getElementById('result').textContent = 'Failed to send request';
        console.error(err);
      }
    });
  }
});
