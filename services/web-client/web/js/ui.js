// ui.js
export function updateLoginState(username) {
    document.getElementById('loginBtn').style.display = 'none';
    document.getElementById('logoutBtn').style.display = 'inline';
    document.getElementById('user-info').textContent = `Hello ${username}`;
    document.getElementById('purchaseHistorySection').style.display = 'block';
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

export function renderPurchaseHistory(history) {
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
        } else if (['COMPLETED', 'SUCCESS'].includes(p.status)) {
            completed.innerHTML += row + '</tr>';
        } else if (['REJECTED', 'FAILED'].includes(p.status)) {
            rejected.innerHTML += row + `<td>${p.reason || ''}</td></tr>`;
        }
    });
}

export function showHelloResponse(text) {
    document.getElementById('helloResponse').textContent = text;
}
