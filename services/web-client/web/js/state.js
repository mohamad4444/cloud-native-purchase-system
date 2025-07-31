// state.js

let accessToken = sessionStorage.getItem('accessToken') || '';
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

export function addItem(id, item) {
    selectedItems[id] = item;
    sessionStorage.setItem('selectedItems', JSON.stringify(selectedItems));
}

export function getSelectedItems() {
    return selectedItems;
}

export function clearSelectedItems() {
    selectedItems = {};
    sessionStorage.removeItem('selectedItems');
}
