// ui.js
export function updateLoginState(username) {
    document.getElementById('loginBtn').style.display = username ? 'none' : 'inline';
    document.getElementById('logoutBtn').style.display = username ? 'inline' : 'none';
    document.getElementById('user-info').textContent = username ? `Hello ${username}` : '';
    document.getElementById('purchaseHistorySection').style.display = username ? 'block' : 'none';
    document.getElementById('inventorySection').style.display = username ? 'block' : 'none';
}

export function renderInventory(products) {
    const tbody = document.getElementById('inventoryList');
    tbody.innerHTML = '';

    if (!products || products.length === 0) {
        tbody.innerHTML = `<tr><td colspan="4">No products available</td></tr>`;
        return;
    }

    products.forEach(p => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${p.product}</td>
            <td>${p.quantity}</td>
            <td><input type="number" min="1" max="${p.quantity}" value="1" id="qty-${p.id}" class="purchase-qty"></td>
            <td><input type="checkbox" class="select-checkbox" data-id="${p.id}" data-name="${p.product}"></td>
        `;
        tbody.appendChild(row);
    });
}

export function renderPurchaseHistory(history, status) {
    const targetMap = {
        'PENDING': 'pendingTableBody',
        'CONFIRMED': 'completedTableBody',
        'REJECTED': 'rejectedTableBody'
    };
    const tbody = document.getElementById(targetMap[status]);
    tbody.innerHTML = '';

    history.forEach(p => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${p.productName}</td>
            <td>${p.quantity}</td>
            <td>${new Date(p.timestamp).toLocaleString()}</td>
            ${status === 'REJECTED' ? `<td>${p.reason || ''}</td>` : ''}
        `;
        tbody.appendChild(row);
    });
}
