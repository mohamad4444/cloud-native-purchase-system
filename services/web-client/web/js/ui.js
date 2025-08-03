// ui.js
export function updateLoginState(username) {
    if (username) {
        // Logged in UI
        document.getElementById('loginBtn').style.display = 'none';
        document.getElementById('logoutBtn').style.display = 'inline';
        document.getElementById('user-info').textContent = `Hello ${username}`;
        document.getElementById('purchaseHistorySection').style.display = 'block';
    } else {
        // Logged out UI
        document.getElementById('loginBtn').style.display = 'inline';
        document.getElementById('logoutBtn').style.display = 'none';
        document.getElementById('user-info').textContent = '';
        document.getElementById('purchaseHistorySection').style.display = 'none';
    }
}

export function renderInventory(inventory) {
    const list = document.getElementById('inventoryList');
    list.innerHTML = '';

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
        list.appendChild(col);
    });

    document.getElementById('inventorySection').style.display = 'block';
}

export function renderPurchaseHistory(history, status) {
    const pending = document.getElementById('pendingTableBody');
    const confirmed = document.getElementById('completedTableBody');
    const rejected = document.getElementById('rejectedTableBody');

    // Only clear the specific section to avoid erasing others
    let target;
    switch (status) {
        case 'PENDING':
            pending.innerHTML = '';
            target = pending;
            break;
        case 'CONFIRMED':
            confirmed.innerHTML = '';
            target = confirmed;
            break;
        case 'REJECTED':
            rejected.innerHTML = '';
            target = rejected;
            break;
        default:
            console.warn(`Unknown status: ${status}`);
            return;
    }

    history.forEach(p => {
        const rowBase = `<tr><td>${p.productName}</td><td>${p.quantity}</td><td>${new Date(p.timestamp).toLocaleString() || ''}</td>`;
        if (status === 'REJECTED') {
            target.innerHTML += rowBase + `<td>${p.reason || ''}</td></tr>`;
        } else {
            target.innerHTML += rowBase + `</tr>`;
        }
    });
}


