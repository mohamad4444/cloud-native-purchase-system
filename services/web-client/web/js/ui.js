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

export function renderInventory(products) {
    const inventorySection = document.getElementById("inventorySection");
    const inventoryList = document.getElementById("inventoryList");

    inventorySection.style.display = "block";
    inventoryList.innerHTML = "";
    console.log(products);
    if (!products || products.length === 0) {
        const row = document.createElement("tr");
        row.innerHTML = `<td colspan="4">No products available</td>`;
        inventoryList.appendChild(row);
        return;
    }

    products.forEach(product => {
        const row = document.createElement("tr");
        row.innerHTML = `
            <td>${product.product}</td>
            <td>${product.quantity}</td>
            <td><input type="number" min="1" max="${product.quantity}" value="1" class="purchase-qty"></td>
            <td><input type="checkbox" data-id="${product.id}"></td>
        `;
        inventoryList.appendChild(row);
    });
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


