## Augmented Spotify API

### Description
Acts as a proxy to the Spotify artists API and augments the response with sensory marketing attribtues.

### Design Notes
  - Metadata attributes are assumed to be calculated by a separate analytics system. This API exposes an endpoint for such system to consume and store metadata.
  - The Spotify API Token is shared between all instances of the Spotify class within the same function instance. This means that a new token will be requested on every cold start, and reused on every warm call. Under high concurrency scenarios, it is recommended to refactor the code in order to manage the token using a secure parameter store service (e.g.: AWS Systems Manager).
  - This prototype is using API Gateway to expose the functions for simplicity (proxy integration) and cost effectiveness particular to this use case, however it can be configured to run behind an application load balancer.

### TODO
  - Add unit and integration tests
  - Add input validation for POST /artists/:id/metadata API endpoint

