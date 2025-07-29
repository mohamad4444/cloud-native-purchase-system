import Keycloak from 'https://cdn.jsdelivr.net/npm/keycloak-js@26.2.0/+esm';

console.log("App loaded!");

document.addEventListener('DOMContentLoaded', () => {
  console.log("DOM fully loaded and parsed");

  const keycloak = new Keycloak({
    url: 'http://localhost:8180/',
    realm: 'purchase-service-realm',
    clientId: 'web-frontend-client'
  });

  let selectedItems = {};

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

    bindLoginLogout();
  }).catch(err => {
    console.error('Keycloak init error:', err);
  });

  function bindLoginLogout() {
    document.getElementById('loginBtn').addEventListener('click', () => {
      keycloak.login({ redirectUri: window.location.href });
    });

    document.getElementById('logoutBtn').addEventListener('click', () => {
      keycloak.logout({ redirectUri: window.location.href });
    });

    document.getElementById('callUserHello').addEventListener('click', () => {
      callHelloEndpoint('http://localhost:8080/helloUser');
    });

    document.getElementById('callAdminHello').addEventListener('click', () => {
      callHelloEndpoint('http://localhost:8080/helloAdmin');
    });
  }

  async function callHelloEndpoint(url) {
    try {
      const response = await fetch(url, {
        headers: { 'Authorization': 'Bearer ' + keycloak.token }
      });

      if (!response.ok) throw new Error(`HTTP ${response.status}`);

      const text = await response.text();
      document.getElementById('helloResponse').textContent = `Response: ${text}`;
    } catch (err) {
      document.getElementById('helloResponse').textContent = `Error: ${err}`;
    }
  }

  function onAuthenticated() {
    document.getElementById('loginBtn').style.display = 'none';
    document.getElementById('logoutBtn').style.display = 'inline';
    document.getElementById('user-info').textContent = `Hello ${keycloak.tokenParsed?.preferred_username}`;
    window.accessToken = keycloak.token;

    fetchInventoryList();
    fetchPurchaseHistory();
    document.getElementById('purchaseHistorySection').style.display = 'block';

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

    bindInventorySelection();
    bindFinalizePurchase();
  }

  async function fetchInventoryList() {
    try {
      const response = await fetch('http://localhost:8081/inventory', {
        headers: { 'Authorization': 'Bearer ' + keycloak.token }
      });
      if (!response.ok) throw new Error(`HTTP ${response.status}`);

      const inventory = await response.json();

      const inventoryList = document.getElementById('inventoryList');
      inventoryList.innerHTML = '';

      inventory.forEach(item => {
        const col = document.createElement('div');
        col.className = 'col-md-4';

        col.innerHTML = `
          <div class="card mb-3 border-primary">
            <div class="card-body">
              <h5 class="card-title">${item.product}</h5>
              <p class="card-text">Stock: ${item.quantity}</p>
              <input type="number" min="1" max="${item.quantity}" class="form-control mb-2" id="qty-${item.id}" placeholder="Quantity">
              <button class="btn btn-outline-primary btn-sm select-btn" data-id="${item.id}" data-name="${item.product}">Select</button>
            </div>
          </div>
        `;
        inventoryList.appendChild(col);
      });

      document.getElementById('inventorySection').style.display = 'block';
    } catch (err) {
      console.error('Failed to load inventory:', err);
    }
  }

  function bindInventorySelection() {
    const inventoryList = document.getElementById('inventoryList');
    inventoryList.addEventListener('click', e => {
      if (!e.target.classList.contains('select-btn')) return;

      const btn = e.target;
      const id = btn.dataset.id;
      const name = btn.dataset.name;
      const qtyInput = document.getElementById(`qty-${id}`);
      const quantity = parseInt(qtyInput.value);

      if (!quantity || quantity < 1) {
        alert("Please enter a valid quantity");
        return;
      }

      selectedItems[id] = { productName: name, quantity };

      btn.classList.remove('btn-outline-primary');
      btn.classList.add('btn-success');
      btn.textContent = 'Selected';

      qtyInput.value = ''; // clear input for next
    });
  }

  function bindFinalizePurchase() {
    document.getElementById('finalizePurchaseBtn').addEventListener('click', async () => {
      if (Object.keys(selectedItems).length === 0) {
        alert("No items selected for purchase");
        return;
      }

      for (const item of Object.values(selectedItems)) {
        try {
          const res = await fetch('http://localhost:8080/api/purchase', {
            method: 'POST',
            headers: {
              'Authorization': 'Bearer ' + keycloak.token,
              'Content-Type': 'application/json'
            },
            body: JSON.stringify(item)
          });

          if (!res.ok) {
            const text = await res.text();
            console.error(`Purchase error for ${item.productName}: ${text}`);
          }
        } catch (err) {
          console.error('Failed to send purchase:', err);
        }
      }

      alert("Purchase request(s) sent!");
      selectedItems = {};
      await fetchInventoryList();
      await fetchPurchaseHistory();
    });
  }

  async function fetchPurchaseHistory() {
    try {
      const res = await fetch('http://localhost:8080/api/purchases', {
        headers: { 'Authorization': 'Bearer ' + keycloak.token }
      });
      if (!res.ok) throw new Error(`HTTP ${res.status}`);

      const history = await res.json();

      const pending = document.getElementById('pendingTableBody');
      const completed = document.getElementById('completedTableBody');
      const rejected = document.getElementById('rejectedTableBody');

      pending.innerHTML = '';
      completed.innerHTML = '';
      rejected.innerHTML = '';

      history.forEach(p => {
        const row = `<tr><td>${p.productName}</td><td>${p.quantity}</td><td>${new Date(p.timestamp).toLocaleString() || ''}</td>`;
        if (p.status === 'PENDING') {
          pending.innerHTML += row + '</tr>';
        } else if (p.status === 'COMPLETED' || p.status === 'SUCCESS') {
          completed.innerHTML += row + '</tr>';
        } else if (p.status === 'REJECTED' || p.status === 'FAILED') {
          rejected.innerHTML += row + `<td>${p.reason || ''}</td></tr>`;
        }
      });
    } catch (err) {
      console.error("Failed to fetch purchase history:", err);
    }
  }
});
