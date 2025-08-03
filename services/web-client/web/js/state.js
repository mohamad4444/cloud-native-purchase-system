// state.js

let accessToken = sessionStorage.getItem('accessToken') || '';
// selectedItems: { [id]: quantity }
let selectedItems = JSON.parse(sessionStorage.getItem('selectedItems')) || {};

export function setToken(token) {
    accessToken = token;
    if (token) {
        sessionStorage.setItem('accessToken', token);
    } else {
        sessionStorage.removeItem('accessToken');
    }
}

export function getToken() {
    return accessToken;
}

// Adds or updates the quantity for an item ID
export function addItem(id, quantity) {
    if (quantity > 0) {
        selectedItems[id] = quantity;
    } else {
        delete selectedItems[id];
    }
    sessionStorage.setItem('selectedItems', JSON.stringify(selectedItems));
}

export function getSelectedItems() {
    return { ...selectedItems }; // return a shallow copy to avoid external mutations
}

export function removeItem(id) {
    delete selectedItems[id];
    sessionStorage.setItem('selectedItems', JSON.stringify(selectedItems));
}

export function clearSelectedItems() {
    selectedItems = {};
    sessionStorage.removeItem('selectedItems');
}
