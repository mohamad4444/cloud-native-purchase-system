# Make your first purchase

The outcome of this tutorial is a purchase that moves from `PENDING` to `CONFIRMED`, with the corresponding inventory quantity reduced. A rejected request instead reaches `REJECTED`. Start with the core services and port forwards from [local Kubernetes](local-kubernetes.md).

## Sign in

Open <http://localhost:4200> and use the login control. The browser client uses the realm `purchase-service-realm` and client `web-frontend-client`. The custom Keycloak image imports the realm JSON on startup.

Use an application user with the `USER` role. If you need to create one, open the Keycloak admin console at <http://localhost:8080>, inspect the local admin configuration, create a user in `purchase-service-realm`, set a password, and assign the appropriate realm or frontend client role. Admin access to the console alone does not grant the application role. See [authentication](../concepts/authentication.md) if the API returns 401 or 403.

## Read inventory and submit an order

Load the inventory in the UI. The API returns only products whose quantity is greater than zero. Pick an available item and submit a small positive quantity, such as one unit. Record its ID and quantity so you can compare afterward.

For an equivalent API experiment, obtain a current application access token from your own browser session and set it in a terminal:

```bash
read -rsp 'Application access token: ' ACCESS_TOKEN
echo
curl --fail-with-body http://localhost:8002/inventory-api/inventory \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

Use the returned `id` as `lagerItemId` and the returned `product` as `productName`. The following JSON is illustrative; replace its ID and name with an actual inventory entry:

```bash
curl --fail-with-body http://localhost:8001/purchase-api/purchases \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{"lagerItemId":1,"productName":"Example product","quantity":1}'
```

The current controller responds with HTTP **200** and a purchase containing `id`, `productName`, `quantity`, and `timestamp`. The response DTO does **not** contain status. Receiving this response means the HTTP operation returned; the asynchronous inventory decision can still be in flight.

## Verify completion

Refresh purchase history in the UI or query confirmed purchases after allowing time for both JMS listeners:

```bash
curl --fail-with-body 'http://localhost:8001/purchase-api/purchases?status=CONFIRMED' \
  -H "Authorization: Bearer $ACCESS_TOKEN"
curl --fail-with-body http://localhost:8002/inventory-api/inventory \
  -H "Authorization: Bearer $ACCESS_TOKEN"
unset ACCESS_TOKEN
```

Find the new purchase by its ID in the filtered list. Its inventory quantity should be one lower; a product with zero stock disappears from the list. You can also filter with `PENDING` and `REJECTED`. The [API reference](../reference/api.md) describes the exact fields and filters.

## Trace the messages

Inspect both services:

```bash
kubectl logs -n dev deployment/purchase --tail=100
kubectl logs -n dev deployment/inventory --tail=100
```

Look for the request being sent, inventory processing the purchase ID, and Purchase receiving the result. The path is `purchase.requested` → inventory decision → `purchase.result` → stored status update.

If a purchase remains pending, inspect the Artemis connection and the two listeners. A successful HTTP response by itself does not prove message processing completed. See [asynchronous purchases](../concepts/messaging.md) for the design and its limits.
