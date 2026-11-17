# HTTP API reference

The two controllers expose three operations. In `dev`, use port 8001 for Purchase and 8002 for Inventory after forwarding their Services. In staging, both are under `https://frontend.local`. Requests require a Keycloak bearer access token with the mapped `USER` role.

## Operations

| Method | Path | Request | Successful response |
| --- | --- | --- | --- |
| GET | `/inventory-api/inventory` | No body | 200, array of in-stock products |
| POST | `/purchase-api/purchases` | Purchase input JSON | 200, purchase DTO |
| GET | `/purchase-api/purchases` | Optional `status` query parameter | 200, array of purchase DTOs |

## Inventory products

The response has this shape:

```json
[
  {"id": 1, "product": "Example product", "quantity": 10}
]
```

This is an illustrative value, not a guaranteed seed record. Inventory filters out entries whose quantity is zero or negative. Select a real `id` from this response when placing a purchase.

## Create a purchase

Request fields come from `PurchaseDtoIn`:

| Field | Java type | Meaning |
| --- | --- | --- |
| `lagerItemId` | `Long` | Inventory product ID; the original domain name is retained |
| `productName` | `String` | Product description recorded with the purchase |
| `quantity` | `int` | Requested quantity |

```json
{"lagerItemId": 1, "productName": "Example product", "quantity": 1}
```

`PurchaseDtoOut` contains:

```json
{
  "id": 42,
  "productName": "Example product",
  "quantity": 1,
  "timestamp": "2026-02-01T12:34:56"
}
```

The timestamp is formatted as an ISO local date-time, without a time-zone offset. **Status and user ID are not included in this DTO.** A successful POST does not guarantee that the asynchronous inventory result has already been processed.

The current controller has no Bean Validation annotations enforcing all business inputs. Use positive quantities for the tutorial; do not treat the absence of a documented validation error as permission to rely on invalid input being handled correctly.

## List and filter purchases

Omit `status` or use `ALL` to list all entries. Supported enum values are `PENDING`, `CONFIRMED`, and `REJECTED`; the controller normalizes case before filtering.

```http
GET /purchase-api/purchases?status=CONFIRMED
Authorization: Bearer ACCESS_TOKEN
```

The filter determines which records are returned, even though status is absent from each returned DTO. An unsupported status reaches enum parsing and can raise an exception; this API does not define a stable validation contract for arbitrary values.

The current repository queries do not restrict purchase history to the authenticated user. The service records the JWT subject at creation, but listing uses `findAll` or `findByStatus`.

## Errors and auxiliary endpoints

Missing or invalid authentication normally produces 401. The security filter chain configures a JSON 403 response for access-denied errors. However, the shared `GlobalExceptionHandler` catches all exceptions reaching MVC advice and returns 500, including enum parsing failures for invalid status values; method-security exceptions can also be affected by this broad handler. Check the underlying error rather than relying on 403 as the only possible indication of a role problem.

The shared 500 response includes `timestamp`, `status`, `error`, and `message`. This broad error handling is part of the current implementation, not a complete API error contract. See [authentication](../concepts/authentication.md) and [troubleshooting](../guides/troubleshooting.md).

Spring Actuator exposes health, info, and Prometheus endpoints in the shared configuration. Only `/actuator/prometheus` is explicitly allowed anonymously. Springdoc dependencies and an OpenAPI bean are present, but the security configuration does not provide an anonymous Swagger/OpenAPI exception.

The source of truth is `PurchaseController`, `ProductController`, their DTOs, and the shared security configuration. This page documents that implementation; it is not a generated OpenAPI specification.
