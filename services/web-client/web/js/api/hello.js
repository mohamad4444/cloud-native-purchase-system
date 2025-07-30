// api/hello.js
export async function callHello(url, token) {
    const res = await fetch(url, {
        headers: { Authorization: 'Bearer ' + token }
    });
    if (!res.ok) throw new Error(await res.text());
    return await res.text();
}
