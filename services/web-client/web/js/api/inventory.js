// api/inventory.js
import { API_ENDPOINTS } from '../config.js';
import { getToken } from '../state.js';
import { renderInventory } from '../ui.js';

export async function fetchInventoryList() {
    try {
        const res = await fetch(API_ENDPOINTS.inventory, {
            headers: { 'Authorization': 'Bearer ' + getToken() }
        });
        const inventory = await res.json();
        renderInventory(inventory);
    } catch (err) {
        console.error("Failed to load inventory:", err);
    }
}
