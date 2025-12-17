# Detektor

Detektor is a device detection library that uses HTTP request headers to make a determination about the client source of the request.

# Usage

Detektor should be passed the entire header object from a request:

```
result = Detektor.detect(request.headers)
```

## Client Hints

To receive `Sec-CH-UA-` headers from a client, your server must request them via response headers. There is a utility provided by this library that will fill the header items for you.

```
# basic usage
Detektor::ClientHints::ResponseBuilder.detecting(Detektor::Everything).apply_headers(response.headers)
```

This utility also can output the request to the client as `<meta>` tag elements that you can render in an HTML webpage.

Note: this method will NOT cause the client to retry requests with additional headers when they are designated "critical", and instead the headers will be added to subsequent requests.

```
# html string
html = Detektor::ClientHints::ResponseBuilder.detecting(Detektor::Everything).to_html
```