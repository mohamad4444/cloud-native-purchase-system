// state.js
let accessToken = '';
let selectedItems = {};

export function setToken(token) {
    accessToken = token;
}

export function getToken() {
    return accessToken;
}

export function addItem(id, item) {
    selectedItems[id] = item;
}

export function getSelectedItems() {
    return selectedItems;
}

export function clearSelectedItems() {
    selectedItems = {};
}
