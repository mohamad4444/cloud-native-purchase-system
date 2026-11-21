# How the project evolved

## Three months of building and learning

I developed the initial project over three months, starting with Docker and Docker Compose. At the time, I had no prior experience with Kubernetes, and this project became my first time using it.

Moving to Kubernetes happened in the final month as a result of what I was building and learning, rather than an architecture planned from day one. TechWorld with Nana's Kubernetes tutorial and the official documentation helped me grasp the core concepts and apply them to my services.

As the system grew, Docker Compose no longer fit the orchestration and deployment patterns I wanted to explore, so I migrated the project to Kubernetes. Maintaining both Compose and Kubernetes configurations would have added unnecessary overhead, so I preserved the earlier implementation as a Git tag instead of supporting both.

## Learning through documentation and source code

I spent substantial time reading official documentation directly—covering Kubernetes resources and networking, Spring Boot and Spring AOP, authentication, messaging, certificates, and observability tools. Tutorials helped me get oriented, but building and debugging the system required reading configuration references closely, diagnosing issues from logs, and verifying behavior through hands-on testing.

Grafana Alloy was a clear example of this. It was unfamiliar to me at the time, with very few video tutorials available—I found only one relevant YouTube video when I started. Most of my learning came from reading Alloy's documentation and tracing how discovery, labels, file collection, and forwarding fit together.

I also studied other people's GitHub repositories, ranging from small, focused examples to larger codebases, to compare patterns against the documentation and see how to adapt them here.

## Preserved versions

| Tag | Purpose |
| :--- | :--- |
| `Docker-Compose-Version` | Historical Docker Compose implementation; no longer maintained |
| `pre-zensical` | Commit `b0e81f1e2e03e2289a4ba38446f3d3ae77bbbd09`, tagged prior to the Zensical documentation migration |

## Learning references

These are starting points for key concepts used in the project rather than a complete bibliography:

* **TechWorld with Nana:** Introductory Kubernetes tutorial.
* **Kubernetes documentation:** Workloads, Services, configuration, and networking.
* **Spring AOP documentation:** Aspects and proxy-based interception.
* **Grafana Alloy documentation:** Component configuration and log collection.

See the repository map to connect these concepts with the implementation.
